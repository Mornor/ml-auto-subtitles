#!/bin/bash

mkdir tmp411
python3 -m pip install moviepy -t tmp411
cp -r ./* tmp411
cd tmp411
zip -r lambda.zip *
