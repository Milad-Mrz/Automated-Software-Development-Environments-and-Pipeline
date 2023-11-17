#!/bin/bash

# Define the content of the .gitlab-ci.yml file
config_content=$(cat <<EOF
image: gradle:6.7.1

stages:
  - build
  - test
  - upload
  - deploy
  - frontend-build
  - frontend-upload
  - frontend-deploy

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
  artifacts:
    name: "backend"
    paths:
    - lu.uni.e4l.platform.api.dev/build/libs/*.jar

test_app:
  stage: test
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew test

build_frontend:
  stage: frontend-build
  script:
    - cd lu.uni.e4l.platform.frontend.dev/
    - npm run build

frontend_upload:
    stage: frontend-upload
    tags:
    - integration
    script:
    - echo "Deploy review app"
    artifacts:
        name: "frontend"
        paths:
        - lu.uni.e4l.platform.frontend.dev/e4l.frontend/web/dist/*

deploy:
    stage: deploy
    tags:
    - integration-shell
    script:
    - cp lu.uni.e4l.platform.api.dev/build/libs/*.jar /home/vagrant/artefact-repository

frontend_deploy:
    stage: frontend-deploy
    tags:
    - integration-shell
    script:
    - cp -r lu.uni.e4l.platform.frontend.dev/e4l.frontend/web/dist/* /home/vagrant/artefact-repository/frontend


EOF
)

# Create the .gitlab-ci.yml file with the specified content
echo "$config_content" > /home/vagrant/e4l/.gitlab-ci.yml