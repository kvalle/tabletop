#!/usr/bin/env bash


pip install --target ./package requests xmltodict

cd package
zip -r9 ${OLDPWD}/function.zip .
cd $OLDPWD

zip -g function.zip lambda_function.py bgg.py
