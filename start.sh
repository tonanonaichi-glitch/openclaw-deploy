#!/bin/bash
set -e
echo "OpenClaw Startup Script"

mkdir -p /root/.openclaw
if [ ! -f /root/.openclaw/config.json ]; then
    echo "{}" > /root/.openclaw/config.json
    fi

    if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
        echo "Error: SLACK_APP_TOKEN, SLACK_BOT_TOKEN, or OPENAI_API_KEY is not set."
            exit 1
            fi
            echo "Enabling Slack plugin..."
            npx openclaw plugins enable slack || true
            echo "Initializing Slack channels..."
            npx openclaw channels remove --channel slack || true
            npx openclaw channels add --channel slack --app-token "$SLACK_APP_TOKEN" --bot-token "$SLACK_BOT_TOKEN"
            echo "Setting Slack configs..."
            npx openclaw channels set-config default --key webhookPath --value "/slack/events"
            npx openclaw channels set-config default --key groupPolicy --value "open"
            npx openclaw channels set-config default --key userTokenReadOnly --value "false"
            echo "Starting OpenClaw Gateway..."
            exec npx openclaw gateway --allow-unconfigured
            
