.PHONY: all
all: build

ROOT := $(shell echo $$(while [ ! -d .git ]; do cd ..; done; pwd))

GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

# Include GOPATH/bin in PATH in order to get protoc-gen-go and friends.
# If missing, install them with:
#   $ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#   $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
PATH := $(shell echo $$PATH:$$(go env GOPATH)/bin)

*.pb.go: ${ROOT}/protos/*.proto
	protoc --go_out=. --go_opt=paths=source_relative \
			--go-grpc_out=. --go-grpc_opt=paths=source_relative \
			-I ${ROOT}/protos \
			${ROOT}/protos/*.proto

.PHONY: clean
clean:
	rm -f *.pb.go

build: *.pb.go
.PHONY: build
