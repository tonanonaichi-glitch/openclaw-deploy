#!/bin/bash
set -e

# Railwayのメモリ不足対策
export NODE_OPTIONS="--max-old-space-size=256"

echo "OpenClaw Startup Script"
if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: Tokens not set"
    exit 1
fi

echo "Generating openclaw.json configuration directly to avoid OOM..."
mkdir -p ~/.openclaw
cat <<JSONEOF > ~/.openclaw/openclaw.json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gpt-4o"
      }
    }
  },
  "channels": {
    "slack": {
      "mode": "socket",
      "webhookPath": "/slack/events",
      "enabled": true,
      "botToken": "${SLACK_BOT_TOKEN}",
      "appToken": "${SLACK_APP_TOKEN}",
      "userTokenReadOnly": false,
      "groupPolicy": "open",
      "streaming": "partial"
    }
  },
  "plugins": {
    "entries": {
      "slack": {
        "enabled": true
      }
    }
  }
}
JSONEOF

echo "Starting Gateway..."
exec npx openclaw gateway
