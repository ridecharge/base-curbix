all: build

build:  
	ansible-galaxy install -r requirements.yml -f
	packer build -only=ubuntu14lts aws.json
