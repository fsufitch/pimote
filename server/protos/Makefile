.PHONY: all
all: build

define PROTOS_SRC_DIR 
$(shell echo $$( \
	while [ ! -d protos_src ]; do \
		cd ..; \
		if [ $$(pwd) = '/' ]; then \
			echo 'protos_src not found' > /dev/stderr; \
			exit 1; \
		fi; \
	done; \
	pwd)/protos_src)
endef

GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

# Include GOPATH/bin in PATH in order to get protoc-gen-go and friends.
# If missing, install them with:
#   $ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#   $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
PATH := $(shell echo $$PATH:$$(go env GOPATH)/bin)

*.pb.go: ${PROTOS_SRC_DIR}/*.proto
	protoc --go_out=. --go_opt=paths=source_relative \
			--go-grpc_out=. --go-grpc_opt=paths=source_relative \
			-I ${PROTOS_SRC_DIR} \
			${PROTOS_SRC_DIR}/*.proto

.PHONY: clean
clean:
	rm -f *.pb.go

build: *.pb.go
.PHONY: build
