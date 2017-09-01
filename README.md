# disconnected_workshops

This project is a set of Ansible scripts to build an environment suitable for hosting partner/customer workshops on a non-Internet-connected environment.

NOTES:
Once you have built the environment, if you wish to skip checking for new RPMs from RHSM, launch the playbook with:
$ ansible-playbook -i hosts main.yml --skip-tags=sync_channels

To get to the documentation, bring up a web browser, and point to the external IP address of the hypervisor host, and go to this URL:
http://<hypervisor external IP>:8020/
