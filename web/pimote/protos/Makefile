all: build

ROOT := $(shell echo $$(while [ ! -d .git ]; do cd ..; done; pwd))

# Include npm bin,to access protoc-gen-ts_proto
PATH := $(shell echo $$PATH:$$(npm bin))

*.ts: ${ROOT}/protos/*.proto
	echo $$PATH
	protoc --ts_proto_out=. \
			-I ${ROOT}/protos \
			${ROOT}/protos/*.proto

.PHONY: clean
clean:
	rm -f *.ts

build: *.ts
.PHONY: build
