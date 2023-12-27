#!/bin/bash

# Wait till cloud-init completes
/usr/bin/cloud-init status --wait

# Enable vSphere guest customisations
echo 'disable_vmware_customization: false' >> /etc/cloud/cloud.cfg
cat <<EOT >> /etc/vmware-tools/tools.conf
[deployPkg]
enable-custom-scripts = true
EOT

rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg \
      /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg \
      /etc/netplan/00-installer-config.yaml \
      /etc/udev/rules.d/70-persistent-net.rules \
      /etc/ssh/ssh_host_*

echo "datasource_list: [ VMware, OVF, None ]" > /etc/cloud/cloud.cfg.d/90_dpkg.cfg

# Reset any existing cloud-init state
systemctl stop cloud-init
cloud-init clean -s -l

systemctl stop rsyslog

#clear audit logs
if [ -f /var/log/audit/audit.log ]; then
    cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    cat /dev/null > /var/log/lastlog
fi

truncate -s 0 /var/log/**/*.log

truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
apt-get -y autoremove
apt-get -y clean
cat /dev/null > ~/.bash_history && history -c

