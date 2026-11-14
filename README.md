# Homebrew Tap

Official [Homebrew](https://brew.sh/) tap for applications and utilities by [@ilamparithi-in](https://github.com/ilamparithi-in).

## Available Software

### Casks (GUI Applications)

| Application | Description | Channel | Install Command |
| :--- | :--- | :--- | :--- |
| **[WAllie](https://github.com/ilamparithi-in/WAllie)** | Unofficial WhatsApp Client with multi-account and extensions | Stable | `brew install --cask ilamparithi-in/tap/wallie` |
| **[WAllie (Nightly)](https://github.com/ilamparithi-in/WAllie)** | Rolling nightly build from latest `main` | Nightly | `brew install --cask ilamparithi-in/tap/wallie@nightly` |

---

## Usage

### Install an application directly
```bash
brew install --cask ilamparithi-in/tap/<name>
```

### Or add the tap first
```bash
brew tap ilamparithi-in/tap
brew install --cask <name>
```

### Updating
```bash
# Update stable casks
brew upgrade --cask <name>

# Update unversioned / nightly casks
brew upgrade --cask --greedy wallie@nightly
```

### Uninstalling
To cleanly uninstall and wipe app caches and preferences:
```bash
brew uninstall --zap --cask <name>
```
