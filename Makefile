# Define the image name
IMAGE_NAME = integration-test:latest

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
.PHONY: run
run:
	docker run --name integration-test-container --rm -v ./:/usr/src/ $(IMAGE_NAME) /bin/sh -c "$(COMMAND)"

