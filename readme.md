# Hajar MacOS Setup

## Install programs

### Package Manager: Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
### Terminal: warp
```bash
brew install --cask warp
```

### SSH Client: Termius
```bash
brew install --cask termius
```

### Spotlight Search: Raycast
```bash
brew install --cask raycast
```

### Note Taking: Notion
```bash
brew install --cask notion
```

### BunJS
```bash
curl -fsSL https://bun.sh/install | bash
```
Add Bun to ~/.zshrc
```bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

```
