# Define the image name
IMAGE_NAME = integration-test:latest
CONTAINER_NAME = integration-test-container

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
.PHONY: run
run:
	docker run --name $(CONTAINER_NAME) $(IMAGE_NAME) /bin/sh -c "$(COMMAND)"

.PHONY: copy
copy:
	docker cp $(CONTAINER_NAME):./usr/src/target .

.PHONY: clean
clean:
	docker rm -f $(CONTAINER_NAME)	

