cask "wallie" do
  arch arm: "-arm64"

  version "1.3.0"
  sha256 arm:   "a66a15d49eeff4cbfc9bceab5f3f4d00e2992bb9be5140db39190d16506f8f3b",
         intel: "7c4102f2c5c2f00e7a28997c36ec85551eb00c4c51eb896a21c5820d60774573"

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
