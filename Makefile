CMAKE=cmake
all: | build
	mkdir -p build
	cd build && $(CMAKE) ..
	${MAKE} -C build

install: all
	${MAKE} -C build install

test:
	${MAKE} -C build test

debug: | build
	mkdir -p build
	cd build && $(CMAKE) .. -DCMAKE_BUILD_TYPE=Debug
	${MAKE} -C build

clean:
	${RM} -r build

check: all
	make -C test test

build:
	mkdir -p $@
