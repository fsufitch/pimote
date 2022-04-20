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

# Include npm bin,to access protoc-gen-ts_proto
PATH := $(shell echo $$PATH:$$(npm bin))

*.ts: ${PROTOS_SRC_DIR}/*.proto
	echo $$PATH
	protoc --ts_proto_out=. \
			-I ${PROTOS_SRC_DIR} \
			${PROTOS_SRC_DIR}/*.proto

.PHONY: clean
clean:
	rm -f *.ts

build: *.ts
.PHONY: build
