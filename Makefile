all: run

clean:
	rm -rf public/ resources/

run:
	hugo server --disableFastRender

build:
	hugo