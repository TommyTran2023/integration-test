# Define the image name
IMAGE_NAME = integration-test:latest

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
.PHONY: run
run:
	docker run --name $(IMAGE_NAME) --rm -v $(pwd):/usr/src/ integration-test:latest /bin/sh -c "$(COMMAND)"

