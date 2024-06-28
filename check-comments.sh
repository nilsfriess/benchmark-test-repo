#!/usr/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: ${0} <PR number>"
    exit 1
fi

PR=$1
output=$(curl -s https://api.github.com/repos/AdaptiveCpp/AdaptiveCpp/issues/${PR}/comments)

if echo "$output" | jq -e 'if type == "array" then true else false end' > /dev/null; then
    lastcomment=$(echo "$output" | jq ".[-1].body")
    
    if [[ $lastcomment =~ "/run-benchmark" ]]; then
	# Lat comment contains /run-benchmark
        exit 0
    else
	# Last comment does not contain /run-benchmark
	exit 1
    fi
else
    # No comments found
    exit 1
fi
