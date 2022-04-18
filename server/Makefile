GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

# Include GOPATH/bin in PATH in order to get protog-gen-go and friends.
# If missing, install them with:
#   $ go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
#   $ go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
PATH := $(shell echo $$PATH:$$(go env GOPATH)/bin)

########## ACTUAL FILE TARGETS ##########

bin/pimote_${GOOS}_${GOARCH}:
	mkdir -p bin
	go build -o ./bin/pimote_${GOOS}_${GOARCH} ./cmd/pimote

protos protos/grpc_%_grpc.pb.go: ../protos/%.grpc.proto
protos protos/%.pb.go: ../protos/%.types.proto
	mkdir -p protos
	protoc --go_out=protos/ --go_opt=paths=source_relative \
			--go-grpc_out=protos/ --go-grpc_opt=paths=source_relative \
			-I ../protos \
			../protos/*.proto
protos: 

########## PHONY TARGETS ##########

deps:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go mod download
.PHONY: deps

build: ./bin/pimote_${GOOS}_${GOARCH}

protos:
	protoc --go_out=protos/ --go_opt=paths=source_relative \
			--go-grpc_out=protos/ --go-grpc_opt=paths=source_relative \
			-I ../protos \
			../protos/*.proto
.PHONY: protos

clean:
	rm -rf ./bin
	./protos/*.go
.PHONY: clean

.DEFAULT: build