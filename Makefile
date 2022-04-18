GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

# Include GOPATH/bin in PATH in order to get protog-gen-go and friends.
# If missing, install them with:
#   $ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#   $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
PATH := $(shell echo $$PATH:$$(go env GOPATH)/bin)

# Find protoc-gen-ts. 
PROTOC_GEN_TS := $(shell cd web && npm exec which protoc-gen-ts_proto)

./bin/pimote_${GOOS}_${GOARCH}:
	mkdir -p bin
	cd server && go build -o ../bin/pimote_${GOOS}_${GOARCH} ./cmd/pimote


build: pimote

protos_server:
	protoc --go_out=server --go_opt=paths=source_relative \
			--go-grpc_out=server --go-grpc_opt=paths=source_relative \
			--plugin=protoc-gen-ts_proto=./web/node_modules/.bin\protoc-gen-ts_proto.cmd
			protos/*.proto
protos_web:

build_protos:
	env | sort
	protoc --go_out=server --go_opt=paths=source_relative \
		--go-grpc_out=server --go-grpc_opt=paths=source_relative \
		--plugin=protoc-gen-ts_proto=./web/node_modules/.bin\protoc-gen-ts_proto.cmd
		protos/*.proto
	

clean:
	rm -rf ./bin

.PHONY: build
.DEFAULT: build