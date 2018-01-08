GIT_COMMIT := $(shell echo "`git rev-parse --short HEAD``git diff-index --quiet HEAD -- || echo '-dirty'`")

all: out/dropbear-$(GIT_COMMIT).hmod

out/dropbear-$(GIT_COMMIT).hmod: mod/bin/dropbear
	mkdir -p "out"
	tar -czvf "$@" -C "mod" "bin" "etc"
	touch "$@"

mod/bin/dropbear: src/dropbear-2015.68/dropbear
	mkdir -p "mod/bin"
	upx --ultra-brute "$<" -o "$@"
	chmod +x "$@"
	touch "$@"

src/dropbear-2015.68/Makefile: src/dropbear-2015.68/configure 
	cd "src/dropbear-2015.68"; \
	./configure --host=arm-linux-gnueabihf --prefix=/ --disable-zlib CC=arm-linux-gnueabihf-gcc LD=arm-linux-gnueabihf-ld
	touch "$@"

src/dropbear-2015.68/dropbear: src/dropbear-2015.68/Makefile
	make -C "src/dropbear-2015.68"

src/dropbear-2015.68/configure: src/dropbear-2015.68.tar.bz2
	tar -xjvf "$<" -C "src/"
	touch "$@"

src/dropbear-2015.68.tar.bz2:
	mkdir -p "src/"
	wget https://github.com/DanTheMan827/dropbear.hmod/releases/download/tarballs/dropbear-2015.68.tar.bz2 -O "$@"

clean: clean-hmod
	-rm -rf "src/"

clean-hmod:
	-rm -rf "out/" "mod/bin/dropbear"

.PHONY: all clean clean-hmod
