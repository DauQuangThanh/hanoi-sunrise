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
  .genreleases/sunrise-template-copilot-"$VERSION".zip \
  .genreleases/sunrise-template-claude-"$VERSION".zip \
  .genreleases/sunrise-template-gemini-"$VERSION".zip \
  .genreleases/sunrise-template-cursor-agent-"$VERSION".zip \
  .genreleases/sunrise-template-opencode-"$VERSION".zip \
  .genreleases/sunrise-template-qwen-"$VERSION".zip \
  .genreleases/sunrise-template-windsurf-"$VERSION".zip \
  .genreleases/sunrise-template-codex-"$VERSION".zip \
  .genreleases/sunrise-template-kilocode-"$VERSION".zip \
  .genreleases/sunrise-template-auggie-"$VERSION".zip \
  .genreleases/sunrise-template-roo-"$VERSION".zip \
  .genreleases/sunrise-template-codebuddy-"$VERSION".zip \
  .genreleases/sunrise-template-amp-"$VERSION".zip \
  .genreleases/sunrise-template-shai-"$VERSION".zip \
  .genreleases/sunrise-template-q-"$VERSION".zip \
  .genreleases/sunrise-template-bob-"$VERSION".zip \
  .genreleases/sunrise-template-jules-"$VERSION".zip \
  .genreleases/sunrise-template-qoder-"$VERSION".zip \
  .genreleases/sunrise-template-antigravity-"$VERSION".zip \
  --title "Hanoi Sunrise - $VERSION_NO_V" \
  --notes-file release_notes.md
