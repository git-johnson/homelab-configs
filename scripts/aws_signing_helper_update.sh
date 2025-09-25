#!/bin/bash
aws_signing_helper update \
  --certificate $CLIENT_CERT \
  --private-key $CLIENT_PRIVATE_KEY \
  --profile-arn $AWS_ROLES_ANYWHERE_PROFILE_ARN \
  --role-arn $AWS_IAM_ROLE_ARN \
  --trust-anchor-arn $AWS_ROLES_ANYWHERE_TRUST_ANCHOR_ARN
