.PHONY: all
all: deps build_all
	@echo === NOTE: To avoid the dependency refresh, run \`make build_all\`

WEBPACK_MODE := development

TARGETS := dist/*
SOURCES := $(shell find $$(ls --ignore dist --ignore node_modules --ignore '.*') -type f)

########## ACTUAL FILE TARGETS ##########

${TARGETS}: ${SOURCES}
	@echo === Build: $@
	@echo = WEBPACK_MODE=${WEBPACK_MODE}
	npx webpack --mode ${WEBPACK_MODE}

########## PHONY TARGETS ##########

.PHONY: deps
deps: package.json package-lock.json
	@echo === Refresh node_modules
	npm install

.PHONY: build
build: ${TARGETS}

.PHONY: build_all
build_all: protos build

.PHONY: watch
watch: protos
	@echo === Webpack Watch
	@echo = Mode: ${WEBPACK_MODE}
	@echo = NOTE: Watch must be restarted if ${ROOT}/protos/* changes
	npx webpack --mode ${WEBPACK_MODE} --watch

.PHONY: protos
protos:
	make -C pimote/protos
	
.PHONY: clean
clean:
	rm -rf ${TARGETS}
	make -C protos clean
