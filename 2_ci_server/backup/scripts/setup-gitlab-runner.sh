#!/bin/bash

# Define the content of the .gitlab-ci.yml file
config_content=$(cat <<EOF
image: gradle:6.7.1

stages:
  - build
  - test
  - upload
  - deploy

cache:
  paths:
    - lu.uni.e4l.platform.api.dev/build/libs/
    - lu.uni.e4l.platform.api.dev/.gradle/

build_app:
  stage: build
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew wrapper
    - chmod +x gradlew
    - ./gradlew clean
    - ./gradlew build

test_app:
  stage: test
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew test

upload_app:
    stage: upload
    tags:
    - integration
    script:
    - echo "Deploy review app"
    artifacts:
        name: "my-app"
        paths:
        - build/libs/*.jar

deploy:
    stage: deploy
    tags:
    - shell
    script:
    - cd lu.uni.e4l.platform.api.dev/
    - cp build/libs/*.jar /home/vagrant/artefact-repository


EOF
)

# Create the .gitlab-ci.yml file with the specified content
echo "$config_content" > /home/vagrant/e4l/.gitlab-ci.yml