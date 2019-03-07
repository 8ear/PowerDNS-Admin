#!/bin/bash
set -x

[ -z "$CONTAINER_NAME" ] && CONTAINER_NAME=powerdns
[ -z "$SLUG" ] && SLUG=8ear

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

EOF

}


func_push(){
	docker push $SLUG/$CONTAINER_NAME:latest
}


#### MAIN ####

[ "$#" = 1 ] || echo "More than one parameter or none parameter. Exit now."
[ "$1" = "push" ] && func_push && exit
[ "$1" = "add_docker-compose.override.yml" ] && func_add_docker-compose.override.yml && exit
[ "$1" = "update" ] && func_update && exit

