# Base Image and Setup

FROM eclipse-temurin:17-jdk-jammy as base
WORKDIR /build
COPY --chmod=0755 mvnw mvnw
COPY .mvn/ .mvn/

# FROM eclipse-temurin:17-jdk-jammy as base: 
# You are using Eclipse Temurin’s JDK 17 (Jammy release) as the base image.

# WORKDIR /build: 
# Sets the working directory for all subsequent commands to /build.

# COPY --chmod=0755 mvnw mvnw: 
# Copies the mvnw (Maven Wrapper) script into the container with executable permissions.

# COPY .mvn/ .mvn/: 
# Copies the .mvn directory containing the Maven wrapper configuration into the container.


# Test Stage

FROM base as test
WORKDIR /build
COPY ./src src/

# FROM base as test: 
# Creates a new stage named test using the previously defined base image.

# WORKDIR /build: 
# Sets the working directory again for this stage to /build.

# COPY ./src src/: 
# Copies your src directory into the container at /build/src/.

# Run Maven Test
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw test

# --mount=type=bind,source=pom.xml,target=pom.xml: 
# This mount binds the pom.xml from the host to the container, ensuring Maven uses the correct configuration for the build.

# --mount=type=cache,target=/root/.m2: 
# This mount caches your Maven dependencies to avoid downloading them each time, improving build efficiency.

# ./mvnw test: 
# Runs the Maven wrapper to execute the test goal.

# Notes:
# The RUN statement makes use of Docker’s BuildKit features (--mount) for binding and caching files. 
# Make sure that BuildKit is enabled when building the image.
# The image will run the tests defined in your Maven project after copying all the required files 
# (mvnw, pom.xml, .mvn/, src/).

# Considerations:
# Docker BuildKit: For --mount=type=bind and --mount=type=cache to work, BuildKit must be enabled. 
# You can enable BuildKit by setting the environment variable DOCKER_BUILDKIT=1 or by configuring it in the Docker daemon.
# Maven Dependencies: Caching dependencies with /root/.m2 will speed up subsequent builds, 
# but ensure that this directory is correctly set up for your project.


# Example Docker Build Command with BuildKit:
# DOCKER_BUILDKIT=1 docker build -t my-maven-app .












