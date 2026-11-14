cask "wallie@nightly" do
  arch arm: "-arm64"

  version :latest
  sha256 :no_check

  url "https://github.com/ilamparithi-in/WAllie/releases/download/nightly/WAllie-nightly#{arch}.dmg"
  name "WAllie (Nightly)"
  desc "Unofficial WhatsApp Client with multi-account and extensions"
  homepage "https://github.com/ilamparithi-in/WAllie"

  conflicts_with cask: "wallie"
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
