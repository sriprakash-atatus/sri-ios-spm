#!/bin/zsh

# Usage:
# - in repo root:
# $ ./tools/carthage-shim.sh [carthage commands and parameters]
# - in different directory:
# $ REPO_ROOT="../../" ../../tools/carthage-shim.sh [carthage commands and parameters]
#
# Shims Carthage commands with avoiding rate-limiting on CI.

source "${REPO_ROOT:-.}/tools/secrets/get-secret.sh"

# "In shared environment where several virtual machines are using the same public ip address (like CI),
# carthage user could hit a Github API rate limit. By providing a Github API access token, carthage can get
# a higher rate limit."
# Ref.: https://github.com/Carthage/Carthage/pull/605
if [ "$CI" = "true" ]; then
    # Prefer dd-octo-sts where it exists; otherwise fall back to a token supplied by the
    # workflow (e.g. GITHUB_TOKEN). Only the dd-octo-sts path can revoke its own token.
    if command -v dd-octo-sts > /dev/null 2>&1; then
        export GITHUB_ACCESS_TOKEN=$(dd-octo-sts --disable-tracing token --scope towersignal/towersignal-sdk-ios --policy self.carthage)
        REVOKE_TOKEN=1
    else
        export GITHUB_ACCESS_TOKEN="${GITHUB_ACCESS_TOKEN:-${GITHUB_TOKEN:-}}"
        REVOKE_TOKEN=0
        if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
            echo_warn "No GitHub token available; Carthage will run unauthenticated and may be rate-limited"
        fi
    fi

    # GitHub introduced rate limits for unauthenticated requests to raw.githubusercontent.com
    # (https://github.blog/changelog/2025-05-08-updated-rate-limits-for-unauthenticated-requests/).
    # Carthage fetches binary-only framework JSON manifests from raw.githubusercontent.com without
    # auth by default, causing failures on shared CI runners. Writing a ~/.netrc entry and passing
    # --use-netrc makes Carthage add an Authorization header for that host.
    if [ -n "$GITHUB_ACCESS_TOKEN" ]; then
        printf "machine raw.githubusercontent.com login x-access-token password %s\n" "${GITHUB_ACCESS_TOKEN}" >> ~/.netrc
        chmod 600 ~/.netrc
    fi

    # Set up a single EXIT trap combining all cleanup: revoke the token and remove the netrc entry.
    # A single trap is used because each `trap ... EXIT` call in zsh replaces the previous one.
    trap '[ "$REVOKE_TOKEN" = "1" ] && dd-octo-sts --disable-tracing revoke --token $GITHUB_ACCESS_TOKEN; sed -i "" "/machine raw.githubusercontent.com/d" ~/.netrc 2>/dev/null' EXIT
fi

# --use-netrc is only meaningful when a netrc entry was actually written.
carthage "$@" ${GITHUB_ACCESS_TOKEN:+--use-netrc}
