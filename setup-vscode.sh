#!/bin/bash

# ⚠️ Abort on error
set -e

# 1. Install latest VSCode
echo "🔧 Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
rm -f packages.microsoft.gpg

# 2. Install Trae Themes extension and select Dark
echo "🎨 Installing Trae Themes..."
code --install-extension trae.theme

# 3. Install Custom UI Style extension
echo "🧩 Installing Custom UI Style..."
code --install-extension iocave.customize-ui

# 4. (Optional) Install Geist Mono font from Vercel
echo "🔤 Installing Geist Mono font..."
mkdir -p ~/.local/share/fonts
wget -O /tmp/geist.zip https://github.com/vercel/geist-font/releases/latest/download/geist.zip
unzip -o /tmp/geist.zip -d ~/.local/share/fonts/geist
fc-cache -f -v

# 5. Clone config files
echo "📁 Cloning config from GitHub..."
git clone https://github.com/notliad/vscodeSettings /tmp/vscodeSettings

# 6. Copy settings.json
echo "🛠️ Applying VSCode settings..."
mkdir -p ~/.config/Code/User
cp /tmp/vscodeSettings/settings.json ~/.config/Code/User/settings.json

# 7. Create folder and copy CSS + JS files
echo "📁 Setting up custom UI files..."
mkdir -p ~/vscode-ui
cp /tmp/vscodeSettings/settings.css ~/vscode-ui/
cp /tmp/vscodeSettings/explorerTitleHandler.js ~/vscode-ui/

# 8. Update settings.json with correct paths (file://)
echo "🧠 Updating settings paths..."
CUSTOM_PATH="file://$HOME/vscode-ui"
sed -i "s|file://.*settings.css|$CUSTOM_PATH/settings.css|g" ~/.config/Code/User/settings.json
sed -i "s|file://.*explorerTitleHandler.js|$CUSTOM_PATH/explorerTitleHandler.js|g" ~/.config/Code/User/settings.json

echo ""
echo "✅ Tudo pronto! Agora abra o VSCode e rode o comando:"
echo "→ Custom UI Style: Reload (Ctrl+Shift+P > digite e selecione)"
echo ""
