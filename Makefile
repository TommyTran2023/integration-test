# Define the image name and container name
IMAGE_NAME = integration-test:latest
CONTAINER_NAME = integration-test-container

# Default command to run in the container
COMMAND = "mvn clean test -Dkarate.env=dev -Dkarate.options='--tags @Get_balance_by_vaultType' -DuserName='dev_readwrite_gcp' -Dpass='TvEQwY3ZGbUf' -DdbName='dev_core_svc' -Drerun='true'"

# Maven repository location
MAVEN_REPO = $(JENKINS_PWD)/.m2/repository
SBT_DIR = $(JENKINS_PWD)/.sbt

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

# Run the Docker container with the specified command
.PHONY: run
run:
	mkdir -p $(MAVEN_REPO) $(SBT_DIR) 
	chmod 777 -R $(MAVEN_REPO)
	chmod 777 -R $(SBT_DIR)
	export SBT_HOME=/usr/src/.sbt && export MAVEN_OPTS='-Dmaven.repo.local=/usr/src/.m2/repository'
	ls / -la
	echo $SBT_HOME && echo $MAVEN_OPTS
	docker run --name $(CONTAINER_NAME) --rm -v "$(JENKINS_PWD):/usr/src" -v "$(MAVEN_REPO):/usr/src/.m2/repository" -v "$(SBT_DIR):/usr/src/.sbt" -u "$(JENKINS_USER):$(JENKINS_GROUP)" $(IMAGE_NAME) /bin/sh -c $(COMMAND)

# Copy the target directory from the running container
.PHONY: copy
copy:
	docker cp $(CONTAINER_NAME):/usr/src/target .

# Clean up the Docker container
.PHONY: clean
clean:
	-docker rm -f $(CONTAINER_NAME)
