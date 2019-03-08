#!/bin/bash
set -x

[ -z "$CONTAINER_NAME" ] && CONTAINER_NAME=powerdns-admin
[ -z "$SLUG" ] && SLUG=8ear
[ -z "$DOCKER_USERNAME" ] && DOCKER_USERNAME=$SLUG

# load variables
source .env


func_update(){
	# Update to Mainstream master
	git remote add upstream https://github.com/ngoduykhanh/PowerDNS-Admin.git
	git fetch upstream
	git checkout master
	git merge upstream/master
}

	
func_add_docker-compose.override.yml(){
cat << EOF > docker-compose.override.yml
version: "2.1"

services:
 powerdns-admin:
  image: ${SLUG}/${CONTAINER_NAME}
  ports: 
  - "8080:9191"

 pdns-server:
  ports:
  - "53:53"
  - "53:53/udp"

EOF

}


func_push(){
	[ -z "$DOCKER_PASSWORD" ] && echo "No DOCKER_PASSWORD var is set. Exit now." && exit 1

	echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
	
	docker push "$SLUG"/"$CONTAINER_NAME":latest
	curl https://cloud.docker.com/api/build/v1/source/c2d8dbf0-9162-493c-8b62-cde5e44dce47/trigger/72401227-2da5-4889-b29c-5aeca1a57929/call/
}


#### MAIN ####

[ "$#" = 1 ] || echo "More than one parameter or none parameter. Exit now."
[ "$1" = "push" ] && func_push && exit
[ "$1" = "add_docker-compose.override.yml" ] && func_add_docker-compose.override.yml && exit
[ "$1" = "update" ] && func_update && exit

