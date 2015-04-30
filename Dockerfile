FROM registry.gocurb.internal:80/ansible

RUN apt-get update && \
		apt-get -y upgrade && \
		apt-get -y install unzip build-essential

ADD https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip /tmp/packer_0.7.5_linux_amd64.zip

RUN unzip /tmp/packer_0.7.5_linux_amd64.zip
RUN cp packer* /usr/bin

RUN mkdir /opt/packer
WORKDIR /opt/packer
COPY . .

RUN ["make", "packer"]