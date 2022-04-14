GOARCH := $(shell go env GOARCH)
GOOS := $(shell go env GOOS)

./bin/pimote:
	mkdir -p bin
	cd server && go build -o ../bin/pimote_${GOOS}_${GOARCH} ./cmd/pimote


build: pimote

clean:
	rm -rf ./bin

.PHONY: build
.DEFAULT: build