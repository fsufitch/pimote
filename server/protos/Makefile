GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

# Include GOPATH/bin in PATH in order to get protog-gen-go and friends.
# If missing, install them with:
#   $ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#   $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
PATH := $(shell echo $$PATH:$$(go env GOPATH)/bin)

protos grpc_%_grpc.pb.go: ../../protos/%.grpc.proto
protos %.pb.go: ../../protos/%.types.proto
	mkdir -p protos
	protoc --go_out=protos/ --go_opt=paths=source_relative \
			--go-grpc_out=protos/ --go-grpc_opt=paths=source_relative \
			-I ../protos \
			../protos/*.proto
