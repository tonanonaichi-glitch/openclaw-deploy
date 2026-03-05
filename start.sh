#!/bin/bash
set -e
echo "OpenClaw Startup Script"
if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: Tokens not set"
        exit 1
        fi
        echo "Enabling Slack plugin..."
        npx -y openclaw plugins enable slack || true
        echo "Initializing Slack channels..."
        npx -y openclaw channels remove --channel slack || true
        npx -y openclaw channels add --channel slack --app-token "$SLACK_APP_TOKEN" --bot-token "$SLACK_BOT_TOKEN"
        echo "Applying Slack config..."
        npx -y openclaw channels set-config default --key webhookPath --value "/slack/events"
        npx -y openclaw channels set-config default --key groupPolicy --value "open"
        npx -y openclaw channels set-config default --key userTokenReadOnly --value "false"
        echo "Starting Gateway..."
        exec npx -y openclaw gateway --allow-unconfigured
