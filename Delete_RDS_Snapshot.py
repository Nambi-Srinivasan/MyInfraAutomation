import json
import boto3
import botocore  
import datetime  
import re  
import logging

from datetime import datetime, timedelta, tzinfo
instances = ['prd1','wp2']
client = boto3.client('rds',region_name='us-east-1')

class Zone(tzinfo):
    def __init__(self,offset,isdst,name):
        self.offset = offset
        self.isdst = isdst
        self.name = name
    def utcoffset(self, dt):
        return timedelta(hours=self.offset) + self.dst(dt)
    def dst(self, dt):
        return timedelta(hours=1) if self.isdst else timedelta(0)
    def tzname(self,dt):
        return self.name

UTC = Zone(10,False,'UTC')

# Setting the retention period to 6 days
retentionDate = datetime.now(UTC) - timedelta(days=15)
#retentionDate = datetime.now(UTC) 

def lambda_handler(event, context):  
     source = boto3.client('rds', region_name='us-east-1')
     for instance in instances:
         try:
             
             snapshots = source.describe_db_snapshots(SnapshotType='manual',DBInstanceIdentifier= instance)
             print(snapshots)
             
             
             print('Deleting all DB Snapshots older than %s' % retentionDate)
             for i in snapshots['DBSnapshots']:
                 if i['SnapshotCreateTime'] < retentionDate:
                     print ('Deleting snapshot %s' % i['DBSnapshotIdentifier'])
                     source.delete_db_snapshot(DBSnapshotIdentifier=i['DBSnapshotIdentifier'])

             
             

             
         except botocore.exceptions.ClientError as e:
             raise Exception("Could not create snapshot: %s" % e)

