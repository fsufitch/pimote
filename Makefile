.PHONY: all
all: server web

GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

.PHONY: server
server:
	make -C server

.PHONY: web
web:
	make -C web

.PHONY: run
run: server web
	server/bin/pimote_${GOOS}_${GOARCH} web/dist

.PHONY: watch
watch: server
	parallel \:\:\: \
		'make -C web watch' \
		'server/bin/pimote_${GOOS}_${GOARCH} web/dist'
	