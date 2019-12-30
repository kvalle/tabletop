#!/usr/bin/env bash

pip install --target ./package requests xmltodict

cd package
zip -r9 ${OLDPWD}/function.zip .
cd $OLDPWD

zip -g function.zip lambda_function.py bgg.py

AWS_DEFAULT_REGION=us-east-1

aws lambda update-function-code --function-name arn:aws:lambda:us-east-1:017978203355:function:tabletop-test-api --zip-file fileb://function.zip

rm function.zip
rm -r package
