### Packer vSphere templates

A collection of Packer templates to standardise, and automate the building of VM templates in vSphere.

A number of things are performed during the image building procedure;
- Disable swap (if applicable)
- Installing common packages
- Kernel parameters defined for ip_forward and bridge-nf-call-iptables
- Run package upgrades
- Sanitise the VM ready for templating

Virtual machines are deployed from these templates via cloud-init for automated IP provisioning and startup scripts. These are defined in vSphere guest customisations.

### Assumptions
- Packer is installed where you will be running the build from. Installation instrcutions can be found (https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli#installing-packer)[here].
- Linux and Windows have `VM Guest Customization Specification` defined in the vSphere policies.

### Usage
An example vSphere configuration file has been created at `config.pkgvars.hcl.example`. This file should be copied and updated accordingly to the respective vSphere you would like to provision the template in.

Example for vSphere;
~~~
$ cp config.pkgvars.hcl.example config.pkgvars.hcl
$ vim config.pkgvars.hcl # edit the required parameters
~~~

Deploying a VM template is simple. An example of creating a new Ubuntu 22.04 template in the LON3 vSphere;
~~~
packer init ubuntu-22.04-lts
packer build -var-file=config.pkgvars.hcl ubuntu-22.04-lts
~~~

When complete, the build will power down the template and convert it to a vSphere template in the `vsphere_template_dir` or elsewhere if this has been modified.
