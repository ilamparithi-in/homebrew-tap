cask "wallie" do
  arch arm: "-arm64"

  version "1.4.0"
  sha256 arm:   "5a30281c938e11d46d2066dd54ab3d07086d2acff80cdaa2a2c2406bf141922a",
         intel: "42a63ad86afcddf7e781b8e2d5d0f8bc28c010a074b762a00f47d0b118c2904e"

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
