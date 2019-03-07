
update:
	# Update to Mainstream master
	git remote add upstream https://github.com/ngoduykhanh/PowerDNS-Admin.git
	git fetch upstream
	git checkout master
	git merge upstream/master

CONTAINERNAME:=powerdns
SLUG:=8ear
	
build:
	docker build -f docker/PowerDNS-Admin/Dockerfile \
		--build-args=" \
			ENVIRONMENT=${ENVIRONMENT} \
		" \
		-t $(SLUG)/$(CONTAINERNAME):latest \
		-t powerdns-admin:latest \
		.

push:
	docker push $(SLUG)/$(CONTAINERNAME):latest