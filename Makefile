PIDFILE="server.pid"
LISTEN="127.0.0.1:8104"

install:
	sudo apt install python3-pip
	sudo pip3 install mkdocs mkdocs-material
	sudo mkdir /opt/uur
	sudo chown martin:martin /opt/uur

start:
	mkdocs serve --dev-addr=$(LISTEN) 1>/dev/null 2>/dev/null & echo $$! > $(PIDFILE)

status:
	ps faux | grep $$(cat $(PIDFILE))

stop:
	kill $$(cat $(PIDFILE))

build:
	mkdocs build

clean:
	mkdocs build --clean

restart: stop clean start

# deploy: build
# 	mkdocs gh-deploy
