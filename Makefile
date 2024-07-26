# Define the image name and container name
IMAGE_NAME = integration-test:latest
CONTAINER_NAME = integration-test-container

# Default command to run in the container
COMMAND = "mvn clean test -Dmaven.repo.local=/usr/src/.m2/repository -Dkarate.env=dev -Dkarate.options='--tags @Get_balance_by_vaultType' -DuserName='dev_readwrite_gcp' -Dpass='TvEQwY3ZGbUf' -DdbName='dev_core_svc' -Drerun='true'"

# Maven repository location
MAVEN_REPO = $(JENKINS_PWD)/.m2/repository

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container with the specified command
.PHONY: run
run:
	docker run --name $(CONTAINER_NAME) --rm -v "$(JENKINS_PWD):/usr/src" -v "$(MAVEN_REPO):/usr/src/.m2/repository" -u "$(JENKINS_USER):$(JENKINS_GROUP)" $(IMAGE_NAME) /bin/sh -c $(COMMAND)

# Copy the target directory from the running container
.PHONY: copy
copy:
	docker cp $(CONTAINER_NAME):/usr/src/target .

# Clean up the Docker container
.PHONY: clean
clean:
	-docker rm -f $(CONTAINER_NAME)
