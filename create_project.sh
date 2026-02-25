#!/bin/bash

# Create iOS project structure for Pikachu Game
PROJECT_NAME="PikachuGame"
BUNDLE_ID="com.pikachu.game"

# Create the Xcode project using xcodebuild
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create project structure
mkdir -p "$PROJECT_NAME"
mkdir -p "$PROJECT_NAME/Models"
mkdir -p "$PROJECT_NAME/ViewModels"
mkdir -p "$PROJECT_NAME/Views"
mkdir -p "$PROJECT_NAME/Views/Home"
mkdir -p "$PROJECT_NAME/Views/Game"
mkdir -p "$PROJECT_NAME/Views/Record"
mkdir -p "$PROJECT_NAME/Services"
mkdir -p "$PROJECT_NAME/Utilities"
mkdir -p "$PROJECT_NAME/Resources"
mkdir -p "$PROJECT_NAME/Resources/Assets.xcassets"
mkdir -p "$PROJECT_NAME/Resources/Levels"

echo "Project structure created successfully!"
