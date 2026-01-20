default: all

version=$(shell ver=$$(git log -n 1 --pretty=oneline --format=%D | awk -F, '{print $$1}' | awk '{print $$3}'); \
	if [ "$$ver" = "master" ] ; then \
	ver="master($$(git log -n 1 --pretty=oneline --format=%h))" ; \
	fi ; \
	echo $$ver)

client: 
	mkdir -p build
	go build -ldflags "-X main.version=${version}" ./cmd/ck-client 
	mv ck-client* ./build

server: 
	mkdir -p build
	go build -ldflags "-X main.version=${version}" ./cmd/ck-server
	mv ck-server* ./build

client-dynlib: 
	mkdir -p build
	go build -ldflags "-X main.version=${version}" -buildmode=c-shared -o libck-client.so ./cmd/ck-client 
	mv libck-client* ./build

server-dynlib: 
	mkdir -p build
	go build -ldflags "-X main.version=${version}" -buildmode=c-shared -o libck-server.so ./cmd/ck-server 
	mv libck-server* ./build

install:
	mv build/ck-* /usr/local/bin

all: client server client-dynlib server-dynlib

clean:
	rm -rf ./build/ck-*
