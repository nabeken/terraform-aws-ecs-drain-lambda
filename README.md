# terraform-ecs-drain-lambda

`terraform-ecs-drain-lambda` is a Terraform Module that provisions [getsocial-rnd/ecs-drain-lambda](https://github.com/getsocial-rnd/ecs-drain-lambda).

This repository provides the following:

- A build script to download the release zip package for the Lambda function
- A terraform module that provisions
  - a lambda function resource
  - an EventBridge event to subscribe a particular ASG
