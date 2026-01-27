#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with all template zip files
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

gh release create "$VERSION" \
  .genreleases/sunrise-template-copilot-sh-"$VERSION".zip \
  .genreleases/sunrise-template-copilot-ps-"$VERSION".zip \
  .genreleases/sunrise-template-claude-sh-"$VERSION".zip \
  .genreleases/sunrise-template-claude-ps-"$VERSION".zip \
  .genreleases/sunrise-template-gemini-sh-"$VERSION".zip \
  .genreleases/sunrise-template-gemini-ps-"$VERSION".zip \
  .genreleases/sunrise-template-cursor-agent-sh-"$VERSION".zip \
  .genreleases/sunrise-template-cursor-agent-ps-"$VERSION".zip \
  .genreleases/sunrise-template-opencode-sh-"$VERSION".zip \
  .genreleases/sunrise-template-opencode-ps-"$VERSION".zip \
  .genreleases/sunrise-template-qwen-sh-"$VERSION".zip \
  .genreleases/sunrise-template-qwen-ps-"$VERSION".zip \
  .genreleases/sunrise-template-windsurf-sh-"$VERSION".zip \
  .genreleases/sunrise-template-windsurf-ps-"$VERSION".zip \
  .genreleases/sunrise-template-codex-sh-"$VERSION".zip \
  .genreleases/sunrise-template-codex-ps-"$VERSION".zip \
  .genreleases/sunrise-template-kilocode-sh-"$VERSION".zip \
  .genreleases/sunrise-template-kilocode-ps-"$VERSION".zip \
  .genreleases/sunrise-template-auggie-sh-"$VERSION".zip \
  .genreleases/sunrise-template-auggie-ps-"$VERSION".zip \
  .genreleases/sunrise-template-roo-sh-"$VERSION".zip \
  .genreleases/sunrise-template-roo-ps-"$VERSION".zip \
  .genreleases/sunrise-template-codebuddy-sh-"$VERSION".zip \
  .genreleases/sunrise-template-codebuddy-ps-"$VERSION".zip \
  .genreleases/sunrise-template-amp-sh-"$VERSION".zip \
  .genreleases/sunrise-template-amp-ps-"$VERSION".zip \
  .genreleases/sunrise-template-shai-sh-"$VERSION".zip \
  .genreleases/sunrise-template-shai-ps-"$VERSION".zip \
  .genreleases/sunrise-template-q-sh-"$VERSION".zip \
  .genreleases/sunrise-template-q-ps-"$VERSION".zip \
  .genreleases/sunrise-template-bob-sh-"$VERSION".zip \
  .genreleases/sunrise-template-bob-ps-"$VERSION".zip \
  .genreleases/sunrise-template-jules-sh-"$VERSION".zip \
  .genreleases/sunrise-template-jules-ps-"$VERSION".zip \
  .genreleases/sunrise-template-qoder-sh-"$VERSION".zip \
  .genreleases/sunrise-template-qoder-ps-"$VERSION".zip \
  .genreleases/sunrise-template-antigravity-sh-"$VERSION".zip \
  .genreleases/sunrise-template-antigravity-ps-"$VERSION".zip \
  --title "Hanoi Sunrise - $VERSION_NO_V" \
  --notes-file release_notes.md
