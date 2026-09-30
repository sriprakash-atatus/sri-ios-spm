#!/usr/bin/env bash
set -euo pipefail

# Validates that the repository is a well-formed, source-based Swift package
# and that its dependencies resolve.
#
# Usage:
#   ./scripts/validate_spm.sh

cd "$(git rev-parse --show-toplevel)"

echo "▸ [validate_spm] Toolchain"
swift --version

echo "▸ [validate_spm] Checking Package.swift exists"
if [[ ! -f Package.swift ]]; then
    echo "✗ Package.swift not found in $(pwd)" >&2
    exit 1
fi

# SwiftPM only reads the tools version from the first line of the manifest; anything above it
# (including comments) makes every `swift package` command fail with a less obvious error.
echo "▸ [validate_spm] Checking the swift-tools-version header is on line 1"
if ! head -n 1 Package.swift | grep -qE '^// ?swift-tools-version:'; then
    echo "✗ Package.swift must start with '// swift-tools-version:' on its first line" >&2
    exit 1
fi

echo "▸ [validate_spm] swift package resolve"
swift package resolve

echo "▸ [validate_spm] swift package dump-package"
swift package dump-package > /dev/null

echo "✓ [validate_spm] Swift package is valid"
