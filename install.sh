#!/usr/bin/env bash
set -e

# Repository information
REPO="husainasfak/vibe"  # Replace with your actual GitHub username/repo
LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
VERSION=$(echo $LATEST_RELEASE | sed 's/^v//')

# Detect the operating system and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Convert OS/ARCH to the naming convention used in releases
case $OS in
  Linux) OS="linux" ;;
  Darwin) OS="darwin" ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*) OS="windows" ;;
  *) echo "OS not supported"; exit 1 ;;
esac

case $ARCH in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Architecture not supported"; exit 1 ;;
esac

# Determine file extension based on OS
if [ "$OS" = "windows" ]; then
  EXT="zip"
else
  EXT="tar.gz"
fi

BINARY="vibe_v${VERSION}_${OS}_${ARCH}.${EXT}"
URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/$BINARY"

echo "Downloading Vibe v${VERSION} for ${OS} (${ARCH})..."
curl -L $URL -o /tmp/$BINARY

# Create temp directory for extraction
TMP_DIR=$(mktemp -d)

# Extract based on file type
if [ "$EXT" = "zip" ]; then
  unzip -q /tmp/$BINARY -d $TMP_DIR
else
  tar -xzf /tmp/$BINARY -C $TMP_DIR
fi

# Installation directories
VIBE_DIR=/usr/local/vibe
VIBE_BIN_DIR=$VIBE_DIR/bin

# Create installation directories with proper permissions
if [ ! -d "$VIBE_DIR" ]; then
  sudo mkdir -p $VIBE_DIR
fi

if [ ! -d "$VIBE_BIN_DIR" ]; then
  sudo mkdir -p $VIBE_BIN_DIR
  sudo chmod 755 $VIBE_BIN_DIR
fi

# Find the vibe binary in the extracted content
VIBE_BINARY=$(find $TMP_DIR -name "vibe" -type f)

if [ -z "$VIBE_BINARY" ]; then
  echo "Error: Could not find vibe binary in the downloaded package"
  exit 1
fi

# Move binary to installation directory and set permissions
sudo cp $VIBE_BINARY $VIBE_BIN_DIR/vibe
sudo chmod 755 $VIBE_BIN_DIR/vibe

# Create symbolic link
sudo ln -sf $VIBE_BIN_DIR/vibe /usr/local/bin/vibe

# Clean up
rm -f /tmp/$BINARY
rm -rf $TMP_DIR

echo "
██╗   ██╗██╗██████╗ ███████╗
██║   ██║██║██╔══██╗██╔════╝
██║   ██║██║██████╔╝█████╗  
╚██╗ ██╔╝██║██╔══██╗██╔══╝  
 ╚████╔╝ ██║██████╔╝███████╗
  ╚═══╝  ╚═╝╚═════╝ ╚══════╝
"
echo "> Vibe v${VERSION} installed successfully!"
echo "> If you get 'command not found' error, add '/usr/local/bin' to your 'PATH' variable."
