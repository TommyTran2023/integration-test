#!/bin/bash

check_url() {
    url="$1"
    errors=()
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" -ne 200 ]; then
        errors+="Error: $url returned HTTP $response"
    fi
    if ((${#errors[@]})); then
    	echo $errors
    	exit 1
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
for url in "${urls[@]}"; do
    check_url "${endpoint}/${env}/${url}"
done

echo "All URLs returned HTTP 200 OK"
