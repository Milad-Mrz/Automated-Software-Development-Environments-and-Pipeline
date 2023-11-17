#!/bin/bash

# Define the content of the .gitlab-ci.yml file
config_content=$(cat <<EOF
image: gradle:6.7.1

stages:
  - backend-build
  - backend-test
  - backend-deploy
  - frontend-build
  - frontend-deploy

cache:
  paths:
    - lu.uni.e4l.platform.api.dev/build/libs/
    - lu.uni.e4l.platform.api.dev/.gradle/

build_app:
  stage: backend-build
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
  stage: backend-test
  script:
    - cd lu.uni.e4l.platform.api.dev/
    - ./gradlew test

build_frontend:
  stage: frontend-build
  script:
    - cd lu.uni.e4l.platform.frontend.dev/
    - npm run build
  artifacts:
        name: "frontend"
        paths:
        - lu.uni.e4l.platform.frontend.dev/e4l.frontend/web/dist/*

deploy:
    stage: backend-deploy
    tags:
    - integration-shell
    script:
    - sudo cp -rf lu.uni.e4l.platform.api.dev/build/libs/*.jar /home/vagrant/shared/
    - sudo echo "1" > /home/vagrant/shared/flag_staging

frontend_deploy:
    stage: frontend-deploy
    tags:
    - integration-shell
    script:
    - sudo cp -rf lu.uni.e4l.platform.frontend.dev/e4l.frontend/web/dist/* /home/vagrant/shared/frontend


EOF
)

# Create the .gitlab-ci.yml file with the specified content
echo "$config_content" > /home/vagrant/e4l/.gitlab-ci.yml