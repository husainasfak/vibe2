#!/usr/bin/env sh
set -e

REPO="yourusername/vibe-cli"
LATEST=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
esac

EXT=""
[ "$OS" = "windows" ] && EXT=".exe"

BIN="vibe${EXT}"
FILE="vibe_${LATEST}_${OS}_${ARCH}.zip"

echo "Downloading $FILE..."
curl -L "https://github.com/$REPO/releases/download/$LATEST/$FILE" -o /tmp/$FILE
unzip /tmp/$FILE -d /tmp
chmod +x /tmp/$BIN
sudo mv /tmp/$BIN /usr/local/bin/vibe

echo "✅ Vibe CLI installed. Run 'vibe health'"