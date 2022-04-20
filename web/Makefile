.PHONY: all
all: protos build

WEBPACK_MODE := development

TARGETS := dist/index.html dist/main.js
SOURCES := $(shell find $$(ls --ignore dist --ignore node_modules --ignore .gitignore --ignore Makefile --ignore README.md) -type f)

########## ACTUAL FILE TARGETS ##########

${TARGETS}&: ${SOURCES}
	# === Build: $@
	# WEBPACK_MODE=${WEBPACK_MODE}
	npx webpack --mode ${WEBPACK_MODE}
	@# XXX: required due to https://github.com/webpack/webpack-dev-middleware/issues/861
	touch ${TARGETS} 

node_modules package-lock.json: package.json
	# === Install dependencies
	npm install

########## PHONY TARGETS ##########

.PHONY: deps
deps: package-lock.json node_modules

.PHONY: build
build: ${TARGETS}

.PHONY: watch
watch: protos
	@echo === Webpack Watch
	@echo = Mode: ${WEBPACK_MODE}
	@echo = NOTE: Watch must be restarted if protobuf sources change
	npx webpack --mode ${WEBPACK_MODE} --watch

.PHONY: protos
protos:
	make -C pimote/protos
	
.PHONY: clean
clean:
	rm -rf ${TARGETS}
	make -C pimote/protos clean
