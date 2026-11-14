cask "wallie" do
  arch arm: "-arm64"

  version "1.2.0"
  sha256 arm:   "7e183b7247ae91e7e1801822421399575dd3902bed85c877a8b79ee90b96c16d",
         intel: "2af7b46e945aff837f604f7fee9605fbaa38682759203ee7b49e24cf3d1ce1e5"

  url "https://github.com/ilamparithi-in/WAllie/releases/download/v#{version}/WAllie-#{version}#{arch}.dmg"
  name "WAllie"
  desc "Unofficial WhatsApp Client with multi-account and extensions"
  homepage "https://github.com/ilamparithi-in/WAllie"

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
