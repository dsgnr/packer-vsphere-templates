#version=RockyLinux9
# Set the authentication options for the system
auth --passalgo=sha512 --useshadow
authselect --enableshadow --passalgo=sha512

# License agreement
eula --agreed

# Use CDROM installation media
cdrom

# Use text mode install
text

# Run the Setup Agent on first boot
firstboot --disable
ignoredisk --only-use=sda

# Firewall configuration
firewall --enabled --ssh

# Keyboard layout
keyboard --vckeymap=${ keyboard } --xlayouts='${ keyboard }'

# System language
lang ${ language }

# Network information
%{ for address in subnets ~}
network --bootproto=static --device=ens192 --activate  --onboot=yes --ip=${ split("/", address)[0] } --netmask=255.255.255.192 --gateway=${ gateway } --nameserver=${ dns_servers } --hostname=${ hostname }
%{ endfor ~}

network --hostname=${ hostname }

# Root password
rootpw ${ password } --iscrypted

# SELinux configuration
selinux --enforcing

# System services
services --enabled="NetworkManager,sshd,chronyd"

# Do not configure the X Window System
skipx

# System timezone
timezone ${ timezone }

# Add the admin user
user --groups=wheel --name=${ username } --password=${ password } --iscrypted

# System bootloader configuration
bootloader --append="crashkernel=auto" --location=mbr

# Clear the Master Boot Record
zerombr

# Remove partitions
clearpart --all --initlabel

# Automatically create partitions using LVM
autopart --type=lvm

# Reboot after successful installation
reboot

%packages --ignoremissing
# yum group info core
@core
# yum group info base
@base
# yum group info "Development Tools"
@Development Tools
# Required packages
openssh-server
open-vm-tools
curl
iputils
tcpdump
net-tools
vim
# Don't install unnecessary firmwares and services
-aic94xx-firmware
-alsa-firmware
-ivtv-firmware
-iwl*firmware
%end

%post

# Disable quiet boot and splash screen
sed --follow-symlinks -i "s/ rhgb quiet//" /etc/default/grub

# Post tasks
echo "${ username } ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${ username }
sed -i -e "s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
yum clean all
%end
