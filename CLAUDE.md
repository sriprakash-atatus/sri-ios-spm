# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the TowerSignal SDK for iOS and tvOS — a modular Swift/Objective-C library for observability (Logs, Traces, RUM, Session Replay, Crash Reporting, WebView Tracking, and Feature Flags).

**Start with `AGENTS.md`** — it is the entry point to all SDK documentation. Follow its pointers to `docs/` for deeper context on architecture, conventions, testing, and development recipes.

## Available Skills

Use these skills (via `/skill-name`) for common workflows:

| Skill | When to use |
|---|---|
| `towersignal-sdk-ios:git-branch` | Creating a new branch for a JIRA ticket or feature |
| `towersignal-sdk-ios:git-commit` | Committing changes (signed commits, message format) |
| `towersignal-sdk-ios:open-pr` | Opening a pull request against `develop` |
| `towersignal-sdk-ios:running-tests` | Running unit, module, or integration tests |
| `towersignal-sdk-ios:xcode-file-management` | Adding, removing, moving, or renaming Swift source files |
| `towersignal-sdk-ios:update-feature-docs` | Review and update all `*_FEATURE.md` docs after public API changes |

## CI Environment

The `ENV=ci` flag enables CI-specific behaviors (e.g., different API surface output paths). Set this when debugging CI failures locally.
