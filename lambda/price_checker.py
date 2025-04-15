import json
import urllib.request
import boto3
import os
from datetime import datetime

def lambda_handler(event, context):
    url = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'
    response = urllib.request.urlopen(url)
    data = json.loads(response.read())

    timestamp = datetime.utcnow().isoformat()
    btc_price = data['bitcoin']['usd']

    filename = f"btc-price-{timestamp}.json"
    s3 = boto3.client('s3')
    s3.put_object(
        Bucket=os.environ['bucket_name'],
        Key=f"prices/{filename}",
        Body=json.dumps({
            'timestamp': timestamp,
            'price_usd': btc_price
        }),
        ContentType='application/json'
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Price saved!')
    }
