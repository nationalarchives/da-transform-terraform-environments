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
    filter_iterator_1 = iterator.search(sort_by)
    filter_iterator_2 = iterator.search(sort_by)
    latest_version_1 = list(filter_iterator_1)[0]
    latest_version_2 = list(filter_iterator_2)[1]
    latest_version = latest_version_1 + " " + latest_version_2
    latest_version = latest_version.strip('latest')
    print(latest_version)
    

    message = event["Records"][0]["Sns"]["Message"].replace('"', '')
    print(message)
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
