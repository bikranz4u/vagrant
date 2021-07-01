#/bin/bash
echo " Installing Basic packages"
echo "COMMAND>> yum install kernel-devel kernel-headers make gcc wget git subversion yum-utils  -y "
yum install kernel-devel kernel-headers make gcc git yum-utils  -y

echo "COMMAND>> yum groups install \"Development Tools\""
yum groups install "Development Tools"


echo "COMMAND>> adduser -aG vboxsf builduser "
adduser -aG vboxsf builduser

# Install Zsh
yum install zsh
chsh -s /usr/bin/zsh root
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
source ~/.zshrc


# Mount External folder
#MOUNT Shared Folder ON VM
#https://help.ubuntu.com/community/VirtualBox/SharedFolders


echo "COMMAND>> Creating External Share Folder............"
echo "Creating External Share Folder............"
sharename="donotshare"
sudo mkdir /mnt/$sharename 
sudo chmod 777 /mnt/$sharename 
sudo mount -t vboxsf -o uid=1000,gid=1000 $sharename /mnt/$sharename 
ln -s /mnt/$sharename $HOME/Desktop/$sharename
