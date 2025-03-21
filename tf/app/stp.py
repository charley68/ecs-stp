from flask import Flask, request
import boto3
import time
import json
import os

app = Flask(__name__)

# DynamoDB Setup
#dynamodb = boto3.resource('dynamodb', region_name="eu-west-2")  # Change region if needed
#TABLE_NAME = os.environ.get('DYNAMODB_TABLE', 'ECS_Requests')
#table = dynamodb.Table(TABLE_NAME)

@app.route('/process', methods=['POST'])
def process():
    xml_data = request.data.decode('utf-8')
    
    # Simulate processing delay
    time.sleep(5)

    # Log to DynamoDB
    #response = table.put_item(
        #Item={
            #'request_id': str(int(time.time())),  # Unique ID
            #'xml_data': xml_data
        #}
    #)

    return {"message": "Processed successfully"}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

