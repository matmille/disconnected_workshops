#!/bin/bash

logfile="tee -a /var/log/pre-workshop_setup.log"

getdate () {
  date=$(date +%Y%m%d%H%M%S)
}

error () {
  getdate
  error="$1"
  printf "[Error|${date}] %s\n" "${error}" | ${logfile}
  exit 1
}

cmd () {
  getdate
  command="$1"
  printf "[cmd|${date}] %s\n" "${command}" | ${logfile}
  bash -c "${command}" 2>&1 | ${logfile} 
  returncode=$?

  getdate
  if [ "${returncode}" = "0" ]; then
	printf "[Success|${date}]\n" | ${logfile}
  else
        error "Return code ${returncode}"
  fi
}

msg () {
  getdate
  message="$1"
  printf "[debug|${date}] %s\n" "${message}" | ${logfile}
    
}

if [ -f "/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" ]; then
  msg 'Import Red Hat Release GPG Key'
  cmd 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release'
else
  error 'Unable to locate: /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release'
  error 'Install redhat-release-server RPM'
fi

msg 'Create local YUM repository to get access disconnected Red Hat Repositories'
cmd 'printf "[RPMs]\nname=RPMs\nenabled=1\ngpgcheck=1\nbaseurl=file:///shared/RPMs\n" > /etc/yum.repos.d/RPMs.repo'
cmd 'chown root:root /etc/yum.repos.d/RPMs.repo'
cmd 'chmod 0644 /etc/yum.repos.d/RPMs.repo'

msg 'Install Ansible Engine'
cmd 'yum clean all'
cmd 'yum -y install ansible'

exit 0
