#!/usr/bin/env bash
set -e

# Repository information
REPO="husainasfak/vibe2"
LATEST_RELEASE=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
VERSION=$(echo $LATEST_RELEASE | sed 's/^v//')
VERSION=${VERSION:-5.5.5}  # Default to 5.5.5 if unable to fetch latest version

echo "Installing Vibe v${VERSION} for Windows..."

# Windows specific binary
BINARY="vibe_v${VERSION}_windows_amd64.zip"
URL="https://github.com/$REPO/releases/download/v${VERSION}/$BINARY"
# If no releases available, construct URL directly
if [ -z "$LATEST_RELEASE" ]; then
  URL="https://github.com/$REPO/releases/download/v${VERSION}/$BINARY"
fi

# Download location
DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

echo "Downloading $BINARY..."
curl -L $URL -o "$DOWNLOAD_DIR/$BINARY"

# Create installation directories
INSTALL_DIR="$HOME/vibe"
BIN_DIR="$INSTALL_DIR/bin"
mkdir -p "$BIN_DIR"

# Extract the zip file
echo "Extracting..."
unzip -o "$DOWNLOAD_DIR/$BINARY" -d "$INSTALL_DIR"

# Find the vibe executable
VIBE_EXE=$(find "$INSTALL_DIR" -name "vibe.exe" -type f)
if [ -z "$VIBE_EXE" ]; then
  # If vibe.exe not found, look for just vibe
  VIBE_EXE=$(find "$INSTALL_DIR" -name "vibe" -type f)
fi

if [ -z "$VIBE_EXE" ]; then
  echo "Error: Could not find vibe executable in the downloaded package"
  exit 1
fi

# Move the executable to bin directory if it's not already there
if [[ "$VIBE_EXE" != "$BIN_DIR"* ]]; then
  cp "$VIBE_EXE" "$BIN_DIR/"
fi

# Add to PATH if not already added
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "Adding $BIN_DIR to PATH in your profile..."
  
  # Determine which profile file to use
  if [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.profile" ]; then
    PROFILE="$HOME/.profile"
  else
    PROFILE="$HOME/.bashrc"
    touch "$PROFILE"
  fi
  
  echo 'export PATH="$HOME/vibe/bin:$PATH"' >> "$PROFILE"
  echo "Please restart your terminal or run 'source $PROFILE' to update your PATH"
fi

# Clean up
rm -f "$DOWNLOAD_DIR/$BINARY"

echo "
██╗   ██╗██╗██████╗ ███████╗
██║   ██║██║██████╔╝█████╗  
██║   ██║██║██╔══██╗██╔════╝
╚██╗ ██╔╝██║██╔══██╗██╔══╝  
 ╚████╔╝ ██║██████╔╝███████╗
  ╚═══╝  ╚═╝╚═════╝ ╚══════╝
"

echo "> Vibe v${VERSION} installed successfully to $BIN_DIR"
echo "> Path has been updated in your profile. Restart your terminal or run 'source $PROFILE'"
echo "> You can now run 'vibe' from your terminal"
