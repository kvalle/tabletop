#!/usr/bin/env bash

./package-lambda.sh

function_arn="arn:aws:lambda:eu-north-1:017978203355:function:tabletop-collection-test"

AWS_DEFAULT_REGION=eu-north-1

aws lambda update-function-code --function-name ${function_arn} --zip-file fileb://function.zip
