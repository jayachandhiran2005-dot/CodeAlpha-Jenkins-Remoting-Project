#!/usr/bin/env bash
set -euo pipefail

: "${JENKINS_URL:?Set JENKINS_URL}"
: "${AGENT_NAME:?Set AGENT_NAME}"
: "${AGENT_SECRET:?Set AGENT_SECRET}"
WORKDIR="${WORKDIR:-$HOME/agent}"

mkdir -p "$WORKDIR"
cd "$WORKDIR"
curl -fsSo agent.jar "${JENKINS_URL%/}/jnlpJars/agent.jar"

# Pass the secret via a file so it doesn't show in the process list
SECRET_FILE="$(mktemp)"
printf '%s' "$AGENT_SECRET" > "$SECRET_FILE"

java -jar agent.jar \
  -url "$JENKINS_URL" \
  -name "$AGENT_NAME" \
  -secret "@$SECRET_FILE" \
  -webSocket \
  -workDir "$WORKDIR"
rm -f "$SECRET_FILE"
