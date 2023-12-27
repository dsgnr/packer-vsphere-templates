#!/bin/bash
# Name: sysprep
# Author: Dan Hand
# About: Sysprep for templating CentOS VMs


# Shows title with name of script.
show_title(){
  local char="="
  local -i count=;

  printf "\n"
  for (( count=0; count<=80; count++ )); do 
    printf "${char}"
  done
  printf "\n                                    ${name}\n"
  printf "                  System Preparation for cloning/imaging (CentOS)\n"
  for (( count=0; count<=80; count++ )); do
    printf "${char}"
  done
  printf "\n\n"
  return 0
}


# Checks if user running the script is superuser (root).
is_user_root(){
  local uid=;
  
  uid=$(id -u)
  # Re-type variable uid from string to integer.
  local -i uid=${uid}
  if [ ${uid} -ne 0 ]; then
    printf "Error: $name should be run by the superuser (root).\n"
    printf "You, $(id -un), are not the superuser.\n"
    printf "Please switch user and execute ${name} again.\n\nBye\n\n"
    exit 1
  fi
  return 0
}


# Check if distribution is CentOS 7 or above.
check_distro(){
  grep "CentOS release [1-6]" /etc/*release &> /dev/null
  if [ $? -eq 0 ]; then
    printf "Error: this version of ${name} is for CentOS 7 and above.\n\n"
    printf "Bye\n\n"
    exit 1
  fi
  return 0
}


main(){
  declare logdir="/var/log"
  declare -a arr_users=()
  declare username=;
  declare name=$(echo $0 | rev)
  declare name=$(echo ${name::10} | rev)
  declare name=${name%???}

  clear
  
  show_title ${name}

  is_user_root ${name}

  check_distro ${name}

  printf "\n\nCleaning (deleting) Yum package cache in /var/cache/yum\n"
  yum clean all

  printf "\nStopping log service rsyslog\n"
  systemctl stop rsyslog.service

  if [ -f  ${logdir}/audit/audit.log ]; then
    printf "\nClobbering ${logdir}/audit/audit.log\n"
    cat /dev/null > ${logdir}/audit/audit.log
  fi 

  printf "\nClobbering log files in ${logdir}\n"
  printf "\n"
  for i in `ls -p ${logdir} | grep -v /`; do
    printf "Clobbering log file ${i}\n"
    cat /dev/null > ${logdir}/${i}
  done

  printf "\nCleaning machine ID\n"
  truncate -s 0 /etc/machine-id

  printf "\nRemoving temporary files from /tmp and /var/tmp\n"
  rm -rf /tmp/*
  rm -rf /var/tmp/*

  printf "\nRemoving udev rules\n"
  rm -f /etc/udev/rules.d/70-persistent-net.rules \

  printf "\nRemoving ~/.ssh dirs to purge user SSH key pairs\n"
  for username in ${arr_users[*]}; do
    [[ -f /home/${username}/.ssh ]] && rm -rf /home/${username}/.ssh
  done
  [[ -f /root/.ssh ]] && rm -rf /root/.ssh

  printf "\nRemoving OpenSSH server SSH key pairs for this host\n"
  printf "(The sshd-keygen.service will generate new keys at boot)\n"
  rm -f /etc/ssh/*key* 
  rm -f /etc/ssh/ssh_host_*

  printf "\nClobbering Bash histories\n"
  for username in ${arr_users[*]}; do
    if [ -f /home/${username}/.bash_history ]; then
      rm -f /home/${username}/.bash_history
      touch /home/${username}/.bash_history
      chown ${username}:users /home/${username}/.bash_history
      chmod 600 /home/${username}/.bash_history
    fi
  done

  printf "\nClobbering bash history for root\n"
  cat /dev/null > ~/.bash_history && history -cw

}
main "$@"
