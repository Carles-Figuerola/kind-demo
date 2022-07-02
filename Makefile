restart: stop start install

install:
	./install.sh

start:
	kind create cluster --name k8s-test

stop:
	killall kubectl || true
	kind delete cluster --name k8s-test
