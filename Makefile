NOW := $(shell date "+%Y%m%d%H%M%S")
VERSION = 1-0
HASH = $(shell git log --pretty=format:'%h' -n 1)
PLAYER_IP = 192.168.70.100
PLUGIN = heartbeat_plugin.brs
SERVER = home.herlein.com:/var/www/heartbeat
SERVER_URL = heartbeat.herlein.com/heartbeat.php

install:
	scp *.php *.html *.sql $(SERVER)

test:
	wget -q -O /dev/null "$(SERVER_URL)?serial=12345678&version=ABC&fw=123&intip=192.168.70.1&event=heartbeat&tag=none" > /dev/null  2>&1 


git_commit: clean
	@-git add *
	@-git commit -am"testing"

plugin_install: git_commit
	curl "$(PLAYER_IP)/delete?filename=sd%2f/$(PLUGIN)&delete=Delete"
	curl -i -F filedata=@$(PLUGIN) http://$(PLAYER_IP)/upload.html?rp=sd
	curl "$(PLAYER_IP)/action.html?reboot=Reboot"

clean:
	@-rm *__* 2>/dev/null || true
	@-rm *~   2>/dev/null || true

