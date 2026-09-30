#!/usr/bin/env bash
set -euo pipefail

# Validates a source-based Swift Package release for a semantic-version tag.
#
# It publishes nothing, creates no Git tags and leaves the working tree untouched,
# so it is safe to run repeatedly. The GitHub Release itself is created by the
# workflow only after this script exits 0.
#
# Usage:
#   ./scripts/release.sh 3.15.0
#   GITHUB_REF_NAME=3.15.0 ./scripts/release.sh
#   RELEASE_TAG=3.15.0 ./scripts/release.sh

ROOT="$(git rev-parse --show-toplevel)"
SCRIPTS="$ROOT/scripts"
cd "$ROOT"

# 1. Read the tag: explicit argument first, then the tag GitHub Actions exposes.
TAG="${1:-${GITHUB_REF_NAME:-${RELEASE_TAG:-}}}"
if [[ -z "$TAG" ]]; then
    echo "✗ No release tag given. Pass it as an argument or set GITHUB_REF_NAME." >&2
    exit 1
fi

# 2. Validate the semantic version. Rejects v1.0.0, 1.0, release-1.0.0 and leading zeros.
if [[ ! "$TAG" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
    echo "✗ Tag '$TAG' is not a semantic version such as 1.0.0" >&2
    exit 1
fi

# 3. Print the release version.
echo "════════════════════════════════════════"
echo " Atatus iOS Agent release: $TAG"
echo " Commit: $(git rev-parse HEAD)"
echo "════════════════════════════════════════"

# 4. Verify Package.swift is present before doing any real work.
echo "▸ [release] Checking Package.swift exists"
if [[ ! -f Package.swift ]]; then
    echo "✗ Package.swift not found in $ROOT" >&2
    exit 1
fi

# Guards against validating a different commit than the one the tag names.
echo "▸ [release] Checking the tag points at the checked-out commit"
if tag_commit="$(git rev-parse -q --verify "refs/tags/$TAG^{commit}")"; then
    if [[ "$tag_commit" != "$(git rev-parse HEAD)" ]]; then
        echo "✗ Tag '$TAG' points at $tag_commit, but HEAD is $(git rev-parse HEAD)" >&2
        exit 1
    fi
else
    echo "  Tag '$TAG' is not present locally; validating HEAD as-is"
fi

# SwiftPM consumers take the version from the tag, but the SDK reports __sdkVersion in its
# payloads and CocoaPods reads s.version, so all three must agree before a release goes out.
echo "▸ [release] Checking SDK and podspec versions match the tag"
sdk_version="$(grep '__sdkVersion' TowerSignalCore/Sources/Versioning.swift | awk -F '"' '{print $2}')"
if [[ "$sdk_version" != "$TAG" ]]; then
    echo "✗ __sdkVersion is '$sdk_version' but the tag is '$TAG'" >&2
    exit 1
fi
for podspec in ./*.podspec; do
    spec_version="$(grep -E '^[[:space:]]*s\.version[[:space:]]*=' "$podspec" | awk -F '"' '{print $2}')"
    if [[ "$spec_version" != "$TAG" ]]; then
        echo "✗ $(basename "$podspec") version is '$spec_version' but the tag is '$TAG'" >&2
        exit 1
    fi
done
echo "  __sdkVersion and all podspecs are $TAG"

# 5-7. Validate the package, then build it, then test it. set -e aborts on the first failure.
"$SCRIPTS/validate_spm.sh"
"$SCRIPTS/build.sh"
"$SCRIPTS/test.sh"

echo "▸ [release] Checking the release left tracked and unignored files unchanged"
if [[ -n "$(git status --porcelain)" ]]; then
    echo "✗ The release modified the working tree:" >&2
    git status --porcelain >&2
    exit 1
fi

echo "✓ [release] $TAG is valid for a source-based Swift Package release"
