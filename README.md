# base-curbix


This is the base image to be used for all other images in the curbformation environment.  

It currently runs Ubuntu 14.04 LTS and provides the follow services exposed as docker containers to be linked against:
* statsd (statsd-docker repo) for librato metrics service
* logging (logging-docker repo) for syslog service
* consul (consul-docker repo) for autodiscovery service
* aws-startup-utils (aws-startup-utils-docker repo) utility scripts for ec2 server startup actions

See the following repos for images built from this:
* ntp-curbix
* nat-curbix

# build
The image is build using a combination of shell, ansible and pulled all together by packer.  The build goes as so:

1. Install ansible via inline shell in the packer definition aws.json
2. Next install the following ansible role repos which are installed by doing bin/install_roles.sh
  * base-ansible-role installs and configures ssh and sudoers as well as common utility packages
  * ntp-ansible-role configures ntp to use our environment ntp servers
  * python3-ansible-role makes sure python3 is installed and any packages
  * logging-ansible-role makes sure syslog-ng is setup to send logs to the docker container and log rotate

3. Restart the image so that the aufs package can finish installing.  This is necessary since the devicemapper fs for docker is buggy and will occasionally fail to start
4. Lastly install docker via the https://get.docker.com/ubuntu/ script and docker pull the images in the previous section.

# startup process
* All ec2 servers will perform the same startup process which will be defined in the cloudformation-templates repo and the instances userdata.
* In the base-ansible-role repo there is a startup.sh script which is triggered by cloudinit/userdata on all ec2 instances
* The startup script requires a NR_TOKEN (new relic) an LOGGLY_TOKEN to be passed in via cloudformation.
* The startup script will then configure and start the newrelic agent
* The startup script will then start the pulled docker containers with necessary settings
