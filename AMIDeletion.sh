#!/bin/bash
> amid.txt
INPUT="/root/imageid.txt"
while read i
do
echo $`echo $i|awk -F, '{print $1}'`
aws ec2 describe-images --image-ids `echo $i|awk -F, '{print $1}'` --query 'Images[].BlockDeviceMappings[].Ebs[].SnapshotId[]' --output text >> amid.txt
done < $INPUT
echo -e "Following are the snapshots associated with it :\n`cat /root/amid.txt`\n "
echo -e "Starting the Deregister of AMI... \n"
for i in `cat /root/imageid.txt`;do aws ec2 deregister-image --image-id $i ; done
echo -e "\nDeleting the associated snapshots.... \n"
for i in `cat /root/amid.txt`;do aws ec2 delete-snapshot --snapshot-id $i ; done
