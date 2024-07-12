# Define the image name
IMAGE_NAME = integration-test:latest
CONTAINER_NAME = integration-test-container
COMMAND ?= "mvn test -Dkarate.env=qa -Dkarate.options=\"--tags @CreateAndEditMembersInGroup\""

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
.PHONY: run
run:
	docker run --name $(CONTAINER_NAME) -u $(jenkinsUid):$(jenkinsGid) $(IMAGE_NAME) /bin/sh -c $(COMMAND) 

.PHONY: copy
copy:
	docker cp $(CONTAINER_NAME):./usr/src/target .

.PHONY: clean
clean:
	docker rm -f $(CONTAINER_NAME) || true

