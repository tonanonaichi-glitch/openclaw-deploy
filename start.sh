#!/bin/bash
set -e
echo "OpenClaw Startup Script"
if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: SLACK_APP_TOKEN, SLACK_BOT_TOKEN, or OPENAI_API_KEY is not set."
        exit 1
        fi
        echo "Enabling Slack plugin..."
        openclaw plugins enable slack || true
        echo "Initializing Slack channels..."
        openclaw channels remove --channel slack || true
        openclaw channels add --channel slack --app-token "$SLACK_APP_TOKEN" --bot-token "$SLACK_BOT_TOKEN"
        echo "Setting Slack configs..."
        openclaw channels set-config default --key webhookPath --value "/slack/events"
        openclaw channels set-config default --key groupPolicy --value "open"
        openclaw channels set-config default --key userTokenReadOnly --value "false"
        echo "Starting OpenClaw Gateway..."
        exec openclaw gateway --allow-unconfigured
