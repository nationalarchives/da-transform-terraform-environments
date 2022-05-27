import urllib3
import json
import os
import boto3

http = urllib3.PoolManager()

def lambda_handler(event, context):
    print(event)
    
    # get the latest parser version
    
    repo_name = 'lambda_functions/tre-run-judgment-parser'
    sort_by = 'sort_by(imageDetails, &to_string(imagePushedAt))[-1].imageTags'
    
    client = boto3.client('ecr')
    
    paginator = client.get_paginator('describe_images')
    
    iterator = paginator.paginate(repositoryName=repo_name)
    filter_iterator = iterator.search(sort_by)
    latest_version = list(filter_iterator)[1]
    

    message = event["Records"][0]["Sns"]["Message"].replace('"', '')
    url = os.environ['SLACK_WEBHOOK_URL']
    if "STARTED" in message:
        icon = ":mega:"
        message = icon+" "+ "A New Version Of Parser Is Available And The `parser-pipeline` STARTED" + "\n" +  "*Old Version:*  " + latest_version
        
    elif "SUCCEEDED" in message:
        icon = ":large_green_circle:"
        message = icon+" "+ message + "\n" + "Latest Parser Version " +latest_version+ " Successfully Deployed To PROD"
    
    elif "FAILED" or "CANCELED" in message:
        icon = ":red_circle:"
        message = icon+" "+message
        
    msg = {
        "channel": os.environ['SLACK_CHANNEL'],
        "username": os.environ['SLACK_USERNAME'],
        "text": message,
        "icon_emoji": icon,
    }
    
    encoded_msg = json.dumps(msg).encode("utf-8")
    http.request("POST", url, body=encoded_msg)
