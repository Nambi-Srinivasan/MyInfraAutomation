import botocore  
import datetime  
import re  
import logging
import boto3
 
region='us-east-1'  
instances = ['qlikdev-db','qlikprd-db']
 
print('Loading function')
 
def lambda_handler(event, context):  
     source = boto3.client('rds', region_name=region)
     for instance in instances:
         try:
             #timestamp1 = '{%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now())
             timestamp1 = str(datetime.datetime.now().strftime('%Y-%m-%d-%H-%-M-%S'))
             snapshotname = "{0}-{1}".format(instance,timestamp1)
             response = source.create_db_snapshot(DBSnapshotIdentifier=snapshotname, DBInstanceIdentifier=instance)
             print(response)
             arnname = response['DBSnapshot'] ['DBSnapshotArn']
             taggging = source.add_tags_to_resource(ResourceName=arnname,Tags=[{'Key': 'Stothebys','Value': 'true'}])
             
         except botocore.exceptions.ClientError as e:
             raise Exception("Could not create snapshot: %s" % e)
