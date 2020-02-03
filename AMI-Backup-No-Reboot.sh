#!/bin/bash
> logbackup
> in.txt

INPUT="/root/instance_ip.txt"
while read i
do
aws ec2 describe-instances --filter Name=private-ip-address,Values=`echo $i|awk -F, '{print $2}'` --query 'Reservations[].Instances[].[Tags[?Key==`Name`]| [0].Value,InstanceId]' --output text | awk -v OFS=, '{$1=$1;print}'>> in.txt
done < $INPUT

INPUT_FILE="/root/in.txt"
#the above command will take input from a text file that contains Instance Name and Instance Id
while read i
do
        Instance_Name=`echo $i|awk -F, '{print $1}'`
        Instance_Id=`echo $i|awk -F, '{print $2}'`

#aws s3 mb s3://logbackup-`date +%Y%m%d%H%M%S

snapname1=$(echo -e "$Instance_Name-`date +%Y%m%d%H%M%S`")

> nambi.json
aws ec2 create-image --instance-id $Instance_Id  --name " $snapname1" --description "An AMI for my server" --no-reboot >> nambi.json
ami=$(jq -r .ImageId nambi.json)

#the above command is used to create image using aws cli which will require programmatic access

echo -e " AMI BACKUP SUCCESSFULLY CREATED FOR $Instance_Name WITH AMI ID $ami AND AMI NAME $snapname1 ON $(date)$ImageId " >> logbackup
done < $INPUT_FILE
                                                                                                                    
a="$(grep -cve '^\s*$' instance_ip.txt)"                                                                                       
echo "${a}"                                                                                                                    
b="$(grep -cve '^\s*$' logbackup)"                                                                                             
echo "${b}"                                                                                                                    
if [ "$a" -eq "$b" ]                                                                                                           
then                                                                                                                           
echo "True"                                                                                                                    
else                                                                                                                           
   echo "False"                                                                                                                
fi