#! /bin/bash

# This script is just a super simple script to ping uptime kuma. 
# Run on a cron job.
# Depends on curl
# Set the following environment variables:
# UPTIME_KUMA_HOST: The host of your uptime kuma instance (e.g. uptime.example.com)
# UPTIME_KUMA_SECRET: The secret key for your push url

curl https://$UPTIME_KUMA_HOST/api/push/$UPTIME_KUMA_SECRET?status=up
