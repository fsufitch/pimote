all: deps protos build

GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

BINFILE := pimote_${GOOS}_${GOARCH}
SOURCES := $(shell find $$(ls --ignore bin) -type f)

########## ACTUAL FILE TARGETS ##########

bin/${BINFILE}: ${SOURCES}
	@echo === Build: $@
	go build -o bin/${BINFILE} ./cmd/pimote

########## PHONY TARGETS ##########

.PHONY: deps
deps: go.mod go.sum
	@echo === Download dependencies for caching
	go mod download -x

.PHONY: build
build: bin/${BINFILE}

.PHONY: protos
protos:
	make -C protos

.PHONY: clean
clean:
	rm -rf bin
	make -C protos clean
