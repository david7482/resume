all: run

CLOUDFRONT_ID=EY29JVG4HSFOH
RESUME_PDF=david-chou.pdf

clean:
	rm -rf public/ resources/

run:
	hugo server --disableFastRender

build:
	hugo --minify

deploy: build
	aws s3 sync ./public s3://david74-resume --delete
	aws s3 cp resume.pdf s3://david74-resume/$(RESUME_PDF)
	aws cloudfront create-invalidation --distribution-id $(CLOUDFRONT_ID) --paths '/index.html' '/$(RESUME_PDF)'
