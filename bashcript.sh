#!/bin/bash
set -euo pipefail

check_awscli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Installing now..."
        install_awscli
    else
        echo "AWS CLI is already installed."
        aws --version
    fi
}

install_awscli() {
    echo "Installing AWS CLI v2 on Linux..."
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt-get install -y unzip &> /dev/null
    unzip -q awscliv2.zip
    sudo ./aws/install
    aws --version
    rm -rf awscliv2.zip ./aws
    echo "AWS CLI installation completed."
}

create_s3_bucket() {
    local bucket_name="my-unique-bucket-$(date +%Y%m%d-%H%M%S)-$$"
    echo "Creating S3 bucket: $bucket_name"
    aws s3 mb "s3://$bucket_name"
    echo "S3 bucket $bucket_name created successfully."
    
    echo "Creating sample object in bucket..."
    echo "Hello World from AWS CLI script" > sample.txt
    aws s3 cp sample.txt "s3://$bucket_name/sample.txt"
    rm -f sample.txt
    echo "Sample object uploaded to S3 bucket."
    
    echo "$bucket_name"
}

wait_for_instance() {
    local instance_id="$1"
    echo "Waiting for instance $instance_id to be in running state..."
    while true; do
        state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].State.Name' --output text)
        if [[ "$state" == "running" ]]; then
            echo "Instance $instance_id is now running."
            break
        fi
        sleep 10
    done
}

create_ec2_instance() {
    local ami_id="add your tags"
    local instance_type="add this according to your requirements"
    local instance_name="add this according to your requirements"
    
    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )
    
    if [[ -z "$instance_id" ]]; then
        echo "Failed to create EC2 instance." >&2
        exit 1
    fi
    
    echo "Instance $instance_id created successfully."
    wait_for_instance "$instance_id"
}

main() {
    check_awscli
    
    echo "Creating S3 bucket with object..."
    bucket_name=$(create_s3_bucket)
    
    echo "Creating EC2 instance..."
    create_ec2_instance
    
    echo "All tasks completed successfully."
}

main "$@"
