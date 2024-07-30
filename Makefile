# Define the image name and container name
IMAGE_NAME = integration-test:latest
CONTAINER_NAME = integration-test-container

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container with the specified command
.PHONY: run
run:
	docker run --name $(CONTAINER_NAME) --rm -v "$(JENKINS_PWD):/usr/src" -u "$(JENKINS_USER):$(JENKINS_GROUP)" $(IMAGE_NAME) /bin/sh -c $(COMMAND)

# Copy the target directory from the running container
.PHONY: copy
copy:
	docker cp $(CONTAINER_NAME):/usr/src/target .

# Clean up the Docker container
.PHONY: clean
clean:
	-docker rm -f $(CONTAINER_NAME)
