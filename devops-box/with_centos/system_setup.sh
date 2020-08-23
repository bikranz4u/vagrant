#!/bin/sh

#----------------------------------------------------------------------------
# Bash settings
#----------------------------------------------------------------------------

# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail

# VARIABLES 
# Use the readonly command to make variables and functions readonly i.e. you cannot change the value of variables.
readonly DOCKER_COMPOSE_VERSION='1.26.2'
readonly TERRAFORM_VERSION="0.13.0"
readonly PACKER_VERSION="1.6.1"

# UTIL PACKAGES
echo " Install Basic packages ....."
echo "----------------------------------------------------------------------------"
yum update -y 
echo "COMMAND >> yum install -y yum-utils git wget curl gcc bash-completion zsh make tree unzip zip"
sudo yum install epel-release
sudo yum install -y yum-utils git wget curl gcc bash-completion zsh make tree unzip zip
sudo yum install python-pip python-devel
sudo yum groupinstall 'development tools'
sudo yum install -y python3

echo " "
echo "----------------------------------------------------------------------------"

#ADD REPO and INSTALL DOCKER ENGINE
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo ""
echo " Add docker latest repo ..... and Install Docker ......."
echo ""
echo "COMMAND >> yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo ""
echo "............"
echo "COMMAND >> yum install -y docker-ce docker-ce-cli containerd.io"
sudo yum install -y docker-ce docker-ce-cli containerd.io
echo "----------------------------------------------------------------------------"

# install pip
pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi

# install ansible
pip3 install --user ansible
pip3 install --user awscli


# START DOCKER

echo " Starting Docker ............"
sudo systemctl enable docker
sudo systemctl start docker
echo ""
echo "............"

# Add user to Docker Group
echo " Add User To docker group ......."
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
echo ""
echo "............"

# Install Docker Compose
echo "Install Docker Compose .............."
echo ""
echo "----------------------------------------------------------------------------"

sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# BASH Completion
echo " Setting UP Terminal :- Installing Bash,zsh, auto completions , Syntax Highlighting ......... "

echo "----------------------------------------------------------------------------"
curl -L https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

# TERMINAL SETUP

curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh; zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
echo " "
echo " "
echo " "

# Customize the Local .vimrc File
touch ~/.vimrc.plug
mkdir ~/vimplug-plugins

echo "setting up vimrc ...."
echo ""
cat << EOF > ~/.vimrc
" Set compatibility to Vim only.
set nocompatible

" Helps force plug-ins to load correctly when it is turned back on below.
filetype off

" Turn on syntax highlighting.
syntax on

" For plug-ins to load correctly.
filetype plugin indent on

" Turn off modelines
set modelines=0

" Automatically wrap text that extends beyond the screen length.
set wrap
" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Uncomment below to set the max textwidth. Use a value corresponding to the width of your screen." 
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5
" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Status bar
set laststatus=2

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Display different types of white spaces.
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" Show line numbers
set number

" Set status line display
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch
" Enable incremental search
set incsearch
" Include matching uppercase words with lowercase search term
set ignorecase
" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"
 
" Call the .vimrc.plug file
if filereadable(expand("~/.vimrc.plug"))
    source ~/.vimrc.plug
endif

"For NerdTree
call pathogen#infect()
syntax on
filetype plugin indent on
EOF


echo "Install NerdTree ........"
# Nerdtree
git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo " "
echo " "

echo "Install NerdTree ........"
#Create the installation directories, download, and install Vim-Plug from Github
sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



echo "Configure vim-plug  ...."
cat << EOF > ~/.vimrc.plug
call plug#begin('~/.vim/plugged')

"Fugitive Vim Github Wrapper
Plug 'tpope/vim-fugitive'

" Nerdtree
Plug 'preservim/nerdtree'
call plug#end()

EOF

# Install TFENV
# mkdir ~/.tfenv
# git clone https://github.com/tfutils/tfenv.git ~/.tfenv
# echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
# ln -s ~/.tfenv/bin/* /usr/local/bin


#terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

#oh My zsh
# yum install zsh powerline fonts-powerline -y
# git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && cd .oh-my-zsh && upgrade_oh_my_zsh
# chsh -s /bin/zsh
# # ZSH Syntax Highlighting & adding to zsh configuration file
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
# echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
