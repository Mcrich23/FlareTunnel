@echo off
REM Build script for FlareTunnel Go version (Windows)

echo 🔨 Building FlareTunnel...
echo.

echo 📦 Downloading dependencies...
go mod download
if errorlevel 1 (
    echo ❌ Failed to download dependencies
    pause
    exit /b 1
)

echo.
echo 🏗️  Building for Windows...
go build -ldflags="-s -w" -o flaretunnel.exe flaretunnel.go
if errorlevel 1 (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo.
echo ✅ Build complete: flaretunnel.exe
echo.
echo 🚀 Quick start:
echo   flaretunnel.exe config              # Configure accounts
echo   flaretunnel.exe create --count 5    # Create workers
echo   flaretunnel.exe list --verbose      # List workers
echo   flaretunnel.exe tunnel --verbose    # Start proxy
echo.

set /p REPLY="Build for other platforms? (y/N) "
if /i "%REPLY%"=="y" (
    echo.
    echo 🌍 Building for multiple platforms...
    
    echo   Building for Linux (amd64)...
    set GOOS=linux
    set GOARCH=amd64
    go build -ldflags="-s -w" -o flaretunnel-linux-amd64 flaretunnel.go
    
    echo   Building for macOS (amd64)...
    set GOOS=darwin
    set GOARCH=amd64
    go build -ldflags="-s -w" -o flaretunnel-macos-amd64 flaretunnel.go
    
    echo   Building for macOS (arm64)...
    set GOOS=darwin
    set GOARCH=arm64
    go build -ldflags="-s -w" -o flaretunnel-macos-arm64 flaretunnel.go
    
    echo.
    echo ✅ Cross-compilation complete!
    echo.
    echo 📦 Built binaries:
    dir /b flaretunnel-*
    echo.
)

echo ✨ Done!
pause

