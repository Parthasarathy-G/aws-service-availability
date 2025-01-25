#!/bin/bash
#####################################################
## Author : Parthasarathy G
## Version : v1.0
## Description : Email sending accoriding aws services availability and unavailability
#####################################################

# List of AWS services to monitor
AWS_SERVICES=("ec2" "s3" "rds")

# Email details
TO_EMAIL="your_email@example.com"
SUBJECT="AWS Service Availability Alert"

# Log file
LOG_FILE="/var/log/aws_service_monitor.log"

# Function to check AWS service status
check_aws_service() {
    local service=$1
    if aws $service describe-instances &> /dev/null; then
        echo "$(date): AWS $service is available." >> "$LOG_FILE"
    else
        echo "$(date): AWS $service is unavailable!" | tee -a "$LOG_FILE" | mail -s "$SUBJECT" "$TO_EMAIL"
    fi
}

# Loop through each AWS service and check its status
for service in "${AWS_SERVICES[@]}"; do
    check_aws_service "$service"
done