#!/bin/bash
# Build script for FlareTunnel Go version

set -e

echo "🔨 Building FlareTunnel..."

# Get dependencies
echo "📦 Downloading dependencies..."
go mod download

# Build for current platform
echo "🏗️  Building for current platform..."
# Note: On macOS, avoid using -s flag as it strips the LC_UUID load command
# which causes dyld to crash with "missing LC_UUID load command" error
if [[ "$OSTYPE" == "darwin"* ]]; then
    go build -o flaretunnel flaretunnel.go
else
    go build -ldflags="-s -w" -o flaretunnel flaretunnel.go
fi

echo "✅ Build complete: ./flaretunnel"
echo ""
echo "📊 Binary size:"
ls -lh flaretunnel | awk '{print $5}'
echo ""
echo "🚀 Quick start:"
echo "  ./flaretunnel config          # Configure accounts"
echo "  ./flaretunnel create --count 5   # Create workers"
echo "  ./flaretunnel list --verbose     # List workers"
echo "  ./flaretunnel tunnel --verbose   # Start proxy"
echo ""

# Optional: Build for other platforms
read -p "Build for other platforms? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "🌍 Building for multiple platforms..."
    
    # Windows
    echo "  Building for Windows (amd64)..."
    GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o flaretunnel-windows-amd64.exe flaretunnel.go
    
    # Linux
    echo "  Building for Linux (amd64)..."
    GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o flaretunnel-linux-amd64 flaretunnel.go
    
    # macOS Intel
    echo "  Building for macOS (amd64)..."
    GOOS=darwin GOARCH=amd64 go build -o flaretunnel-macos-amd64 flaretunnel.go
    
    # macOS Apple Silicon
    echo "  Building for macOS (arm64)..."
    GOOS=darwin GOARCH=arm64 go build -o flaretunnel-macos-arm64 flaretunnel.go
    
    # Linux ARM (Raspberry Pi, etc.)
    echo "  Building for Linux (arm64)..."
    GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o flaretunnel-linux-arm64 flaretunnel.go
    
    echo ""
    echo "✅ Cross-compilation complete!"
    echo ""
    echo "📦 Built binaries:"
    ls -lh flaretunnel-* | awk '{print "  " $9 " - " $5}'
    echo ""
fi

echo "✨ Done!"

