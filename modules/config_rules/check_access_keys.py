import boto3

iam = boto3.client ('iam')

def handler (event, context):
    print ("Processing event: {}".format (event))

    return {"evaluation": "complete"}