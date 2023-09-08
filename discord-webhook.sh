#! /bin/bash

# This script sends a message to a discord webhook.
# It requires the following environment variables to be set:
# - DISCORD_WEBHOOK_URL: The URL of the webhook to send the message to
# - DISCORD_CONTENT: The content of the message to send. This is only used if no arguments are provided to the script
# The following optional environment variables can be set:
# - DISCORD_USERNAME: The username to send the message as
# - DISCORD_AVATAR_URL: The URL of the avatar to send the message with
# This script depends on jq and curl

if [ -z "$DISCORD_WEBHOOK_URL" ]
then
    echo "DISCORD_WEBHOOK_URL not set"
    exit 1
fi

CONTENT="$@"
if [ -z "$CONTENT" ]
then
    CONTENT="$DISCORD_CONTENT"
fi

if [ -z "$CONTENT" ]
then
    echo "No content provided"
    exit 1
fi

JQ_OPTIONAL_ARGS=()

[ -z "$DISCORD_USERNAME" ] || JQ_OPTIONAL_ARGS+=("--arg" "username" "$DISCORD_USERNAME")
[ -z "$DISCORD_AVATAR_URL" ] || JQ_OPTIONAL_ARGS+=("--arg" "avatar_url" "$DISCORD_AVATAR_URL")


BODY=$(jq -n --arg content "$CONTENT" "${JQ_OPTIONAL_ARGS[@]}" '$ARGS.named')

curl -H "Content-Type: application/json" -X POST -d "$BODY" "$DISCORD_WEBHOOK_URL"