#!/bin/bash
set -e

# Railwayのトライアルプラン（512MB RAM）のメモリ不足対策
export NODE_OPTIONS="--max-old-space-size=256"

echo "OpenClaw Startup Script"
if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: Tokens not set"
    exit 1
fi

echo "Configuring OpenAI Provider..."
npx openclaw providers enable openai || true
npx openclaw providers set-config openai --key apiKey --value "$OPENAI_API_KEY" || true
npx openclaw models add --model gpt-4o-mini --provider openai || true
npx openclaw models add --model gpt-4o --provider openai || true

echo "Enabling Slack plugin..."
npx openclaw plugins enable slack || true

echo "Initializing Slack channels..."
npx openclaw channels remove --channel slack || true
npx openclaw channels add --channel slack --app-token "$SLACK_APP_TOKEN" --bot-token "$SLACK_BOT_TOKEN"

echo "Applying Slack config..."
# 設定対象を'default' -> 'slack'に修正
npx openclaw channels set-config slack --key webhookPath --value "/slack/events" || true
npx openclaw channels set-config slack --key groupPolicy --value "open" || true
npx openclaw channels set-config slack --key userTokenReadOnly --value "false" || true

echo "Starting Gateway..."
exec npx openclaw gateway --allow-unconfigured
