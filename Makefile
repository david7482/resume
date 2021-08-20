all: run

CLOUDFRONT_ID="EY29JVG4HSFOH"

clean:
	rm -rf public/ resources/

run:
	hugo server --disableFastRender

build:
	hugo --minify

deploy: build
	aws s3 sync ./public s3://david74-resume --delete
	aws cloudfront create-invalidation --distribution-id $(CLOUDFRONT_ID) --paths '/index.html'