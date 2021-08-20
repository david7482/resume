all: run

clean:
	rm -rf public/ resources/

run:
	hugo server --disableFastRender

build:
	hugo --minify

s3: build
	aws s3 sync ./public s3://david74-resume --delete