#!/usr/bin/env bash
set -euo pipefail

# Runs the Swift package unit tests.
#
# Usage:
#   ./scripts/test.sh            # runs: swift test
#   ./scripts/test.sh <args...>  # extra args are appended to swift test

cd "$(git rev-parse --show-toplevel)"

echo "▸ [test] swift test ${*:-}"
swift test "$@"

echo "✓ [test] Tests passed"
