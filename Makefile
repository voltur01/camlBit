build:
	cd ./examples
	make build
	cd ..

clean:
	rm -rf ./docs/stdlib
	rm -rf ./docs/camlBit

	cd ./lib && $(MAKE) clean
	cd ./examples && $(MAKE) clean

.PHONY: build clean
