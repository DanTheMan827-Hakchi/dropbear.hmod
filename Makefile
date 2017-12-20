all: out/dropbear.hmod
out/dropbear.hmod: mod/bin/dropbear
	[ -f "out/dropbear.hmod" ] || tar -czvf out/dropbear.hmod -C mod bin etc

mod/bin/dropbear: src/dropbear-2015.68/dropbear
	mkdir -p mod/bin
	[ -f mod/bin/dropbear ] || upx --ultra-brute src/dropbear-2015.68/dropbear -o mod/bin/dropbear
	chmod +x mod/bin/dropbear

src/dropbear-2015.68.tar.bz2:
	mkdir -p src
	wget https://github.com/DanTheMan827/dropbear.hmod/releases/download/tarballs/dropbear-2015.68.tar.bz2 -O src/dropbear-2015.68.tar.bz2

src/dropbear-2015.68/configure: src/dropbear-2015.68.tar.bz2
	[ -f src/dropbear-2015.68/configure ] || tar -xjvf src/dropbear-2015.68.tar.bz2 -C src/

src/dropbear-2015.68/Makefile: src/dropbear-2015.68/configure 
	cd src/dropbear-2015.68; \
	./configure --host=arm-linux-gnueabihf --prefix=/ --disable-zlib CC=arm-linux-gnueabihf-gcc LD=arm-linux-gnueabihf-ld

src/dropbear-2015.68/dropbear: src/dropbear-2015.68/Makefile
	make -C src/dropbear-2015.68

clean:
	-rm -rf "out/" "mod/bin/dropbear" "src/"

.PHONY: all clean
