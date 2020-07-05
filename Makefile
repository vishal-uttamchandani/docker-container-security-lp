IMAGE_TAG=0.0.1

default: build

build:
	
	@echo "analyzing dockerfile..."
	@docker run --rm -i hadolint/hadolint < Dockerfile
	@echo "dockerfile passed static analysis!"

	@echo "analyzing security rules..."
	@docker run --rm -i -v $(PWD):/root/ projectatomic/dockerfile-lint dockerfile_lint -r /root/policies/release_rules.yml
	@echo "dockerfile passed security rules check!"

	@echo "building hugo-builder container..."
	@docker build -t vishalu/hugo-builder:$(IMAGE_TAG) .
	@echo "hugo-builder container built!"
	
	@docker images vishalu/hugo-builder:$(IMAGE_TAG)
	
build-website:
	@echo "building orgdocs website using hugo builder container"
	@docker run --rm -it -v $(PWD)/orgdocs:/src -u hugo vishalu/hugo-builder:$(IMAGE_TAG) hugo
	
serve-website:
	@echo "serving orgdocs website using hugo builder container"
	@docker run --rm -it -v $(PWD)/orgdocs:/src -v $(PWD)/tools:/src/tools -p 1313:1313 -u hugo vishalu/hugo-builder:$(IMAGE_TAG) hugo server -w --bind=0.0.0.0

.PHONY: build build-website serve-website
