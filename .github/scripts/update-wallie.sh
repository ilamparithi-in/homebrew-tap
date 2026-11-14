#!/usr/bin/env bash
set -euo pipefail

REPO="ilamparithi-in/WAllie"
CASK_FILE="Casks/wallie.rb"

echo "Fetching latest release information for ${REPO}..."
LATEST_JSON=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest")
TAG_NAME=$(echo "$LATEST_JSON" | jq -r .tag_name)

if [ -z "$TAG_NAME" ] || [ "$TAG_NAME" = "null" ]; then
  echo "Error: Failed to fetch latest release from GitHub API" >&2
  exit 1
fi

VERSION="${TAG_NAME#v}"
CURRENT_VERSION=$(grep -oE 'version "[0-9.]+"' "$CASK_FILE" | head -1 | cut -d'"' -f2)

echo "Current cask version: ${CURRENT_VERSION}"
echo "Latest release version: ${VERSION}"

FORCE="${FORCE_UPDATE:-false}"
if [ "$CURRENT_VERSION" = "$VERSION" ] && [ "$FORCE" != "true" ]; then
  echo "Cask is already up to date."
  exit 0
fi

ARM_URL="https://github.com/${REPO}/releases/download/${TAG_NAME}/WAllie-${VERSION}-arm64.dmg"
INTEL_URL="https://github.com/${REPO}/releases/download/${TAG_NAME}/WAllie-${VERSION}.dmg"

echo "Downloading ARM64 DMG and computing SHA256: ${ARM_URL}"
ARM_SHA=$(curl -sL "$ARM_URL" | sha256sum | awk '{print $1}')

echo "Downloading Intel DMG and computing SHA256: ${INTEL_URL}"
INTEL_SHA=$(curl -sL "$INTEL_URL" | sha256sum | awk '{print $1}')

if [ -z "$ARM_SHA" ] || [ -z "$INTEL_SHA" ]; then
  echo "Error: Could not compute SHA256 checksums" >&2
  exit 1
fi

echo "ARM64 SHA: ${ARM_SHA}"
echo "Intel SHA: ${INTEL_SHA}"

cat << CASK_EOF > "$CASK_FILE"
cask "wallie" do
  arch arm: "-arm64"

  version "${VERSION}"
  sha256 arm:   "${ARM_SHA}",
         intel: "${INTEL_SHA}"

  url "https://github.com/${REPO}/releases/download/v#{version}/WAllie-#{version}#{arch}.dmg"
  name "WAllie"
  desc "Unofficial WhatsApp Client with multi-account and extensions"
  homepage "https://github.com/${REPO}"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with cask: "wallie@nightly"
  depends_on macos: :ventura

  app "WAllie.app"

  zap trash: [
    "~/Library/Application Support/WAllie",
    "~/Library/Application Support/wallie",
    "~/Library/Preferences/dev.ilamparithi.wallie.plist",
    "~/Library/Saved Application State/dev.ilamparithi.wallie.savedState",
  ]

  caveats <<~EOS
    #{token} is not signed with an Apple Developer certificate.
    If macOS blocks opening the app, run:
      xattr -d com.apple.quarantine /Applications/WAllie.app
    Or reinstall using:
      brew install --cask --no-quarantine ilamparithi-in/tap/#{token}
  EOS
end
CASK_EOF

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git add "$CASK_FILE"

if git diff --staged --quiet; then
  echo "No changes detected after regenerating cask."
else
  git commit -m "chore(cask): update wallie to v${VERSION}"
  git push
  echo "Successfully updated and pushed wallie v${VERSION}"
fi
