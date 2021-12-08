#!/bin/bash
export PATH=$PATH:$HOME/bin

please_set_credentials () {
  echo "please pass credentials through environment vars AWS_CLIENT_ID and AWS_CLIENT_SECRET"
  exit 126
}

please_set_region () {
  echo "please set AWS_REGION environment var to a valid region"
  exit 126
}

if [[ "$AWS_REGION" = "define" ]]; then
  please_set_region
fi

if [[ -z "$AWS_CLIENT_ID" ]]; then
  please_set_credentials
fi

if [[ -z "$AWS_CLIENT_SECRET" ]]; then
  please_set_credentials
fi

if [[ "$AWS_REGION" = "define" ]]; then
  please_set_region
fi

if [[ "$AWS_CLIENT_ID" = "define" ]]; then
  please_set_credentials
fi

if [[ "$AWS_CLIENT_SECRET" = "define" ]]; then
  please_set_credentials
fi

aws configure set region "${AWS_REGION}"
aws configure set aws_access_key_id "${AWS_CLIENT_ID}"
aws configure set aws_secret_access_key "${AWS_CLIENT_SECRET}"
aws configure set output json
