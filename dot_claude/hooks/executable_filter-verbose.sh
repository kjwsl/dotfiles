#!/bin/bash
# Filter verbose output from build tools to save tokens

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')

# If no command, pass through
if [ -z "$cmd" ]; then
  echo "$input"
  exit 0
fi

# Filter build output to show only errors and warnings
if [[ "$cmd" =~ ^(make|gcc|g\+\+|arm-none-eabi|cargo build|cargo test) ]]; then
  filtered="($cmd) 2>&1 | grep -E '(error|warning|Error|Warning|FAILED|PASSED|✓|✗)' | head -100 || $cmd"
  echo "$input" | jq --arg cmd "$filtered" '.tool_input.command = $cmd'
  exit 0
fi

# Filter test output to show summary only
if [[ "$cmd" =~ ^(pytest|npm test|cargo test) ]]; then
  filtered="($cmd) 2>&1 | tail -50"
  echo "$input" | jq --arg cmd "$filtered" '.tool_input.command = $cmd'
  exit 0
fi

# Pass through unchanged
echo "$input"
