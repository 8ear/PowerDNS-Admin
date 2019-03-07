
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
		-t $(SLUG)/$(CONTAINERNAME):latest \
		-t powerdns-admin:latest \
		./docker/PowerDNS-Admin/

push:
	docker push $(SLUG)/$(CONTAINERNAME):latest