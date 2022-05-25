import json
from optparse import Option
from typing import Type
import boto3

client = boto3.client('ssm')
response = client.get_parameter(
    Name='dev-tfvars',
    WithDecryption=True
)

print(response)
print(response['Parameter']['Value'])
# print(type(response['Parameter']))
# json_response = json.dumps(response['Parameter'])
# print(type(json_response))

