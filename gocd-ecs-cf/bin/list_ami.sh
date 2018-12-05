#!/bin/bash
if [ -z "$1" ] ; then
    echo "Please pass the name of the AMI"
    exit 1
fi

IMAGE_FILTER="${1}"

declare -a REGIONS=($(aws ec2 describe-regions --output json | jq '.Regions[].RegionName' | tr "\\n" " " | tr "\"" " "))
#echo $REGIONS
#for r in "${REGIONS[@]}" ; do
#	echo $r
#done

for r in "${REGIONS[@]}" ; do
    ami=$(aws ec2 describe-images --filters "Name=name,Values=${IMAGE_FILTER}" "Name=state,Values=available" --region ${r} --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId')
    echo ${r}":"
    echo " AmazonLinux:   ${ami}"
done

#'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
#aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????-x86_64-gp2' 'Name=state,Values=available' --output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
#./list_ami.sh amzn2-ami-hvm-2.0.????????-x86_64-gp2
