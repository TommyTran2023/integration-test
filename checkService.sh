#!/bin/bash

check_url() {
    url="$1"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" -ne 200 ]; then
        echo "Error: $url returned HTTP $response"
        return 1
    fi
}

# List of URLs to check
endpoint="http://acf5a27f1211c42fea8ea78207b527ae-936ee4c7bfbc751f.elb.ap-southeast-1.amazonaws.com"
env="$1"
urls=(
    "core/health"
    "auth/health" 
    "notification/health"
    "crm/health"
    "audit/health"
    "reports/health"
    "openapi/health"
    "staking/health"
    "transaction/health"
)

# Loop through each URL and check response status
errors=0
for url in "${urls[@]}"; do
    check_url "${endpoint}/${env}/${url}"
    if [ $? -eq 1 ]; then
        let "errors++"
    fi
done

if [ "$errors" -eq 0 ]; then
    echo "All URLs returned HTTP 200 OK"
    exit 0
else
    exit 1
fi



