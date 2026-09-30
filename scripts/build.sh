#!/usr/bin/env bash
set -euo pipefail

# Builds the Swift package from source.
#
# Usage:
#   ./scripts/build.sh            # runs: swift build
#   ./scripts/build.sh <args...>  # extra args are appended to swift build

cd "$(git rev-parse --show-toplevel)"

echo "▸ [build] swift build ${*:-}"
swift build "$@"

echo "✓ [build] Build succeeded"
