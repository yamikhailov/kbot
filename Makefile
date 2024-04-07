VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=yamikhailov
APP=$(shell basename $(shell git remote get-url origin))
TARGETOS=linux
TARGETARCH=amd64

all:
	@echo "Hello, World!"

format:
	gofmt -w -s ./

get:
	go get

lint:
	golint

test:
	go test -v 

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -ldflags "-X=github.com/yamikhailov/kbot/cmd.appVersion=${VERSION}" -o kbot

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot