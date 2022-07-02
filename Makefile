restart: cleanup precheck stop-fast start-fast install-fast

install: cleanup precheck install-fast
install-fast:
	./install
	./info

start: cleanup precheck start-fast
start-fast:
	kind create cluster --name k8s-test

stop: cleanup precheck stop-fast
stop-fast:
	kind delete cluster --name k8s-test

cleanup:
	killall kubectl || true

precheck:
	./precheck
