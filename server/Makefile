all: deps protos build

GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

BINFILE := bin/pimote_${GOOS}_${GOARCH}
SOURCES := $(shell find . -type f)

########## ACTUAL FILE TARGETS ##########

${BINFILE}: ${SOURCES}
	@echo === Build: $@
	go build -o ${BINFILE} ./cmd/pimote

########## PHONY TARGETS ##########

.PHONY: deps
deps: go.mod go.sum
	@echo === Download dependencies for caching
	go mod download -x

.PHONY: build
build: ${BINFILE}

.PHONY: protos
protos:
	make -C protos
	
.PHONY: clean
clean:
	rm -rf ${BINFILE}
	make -C protos clean
