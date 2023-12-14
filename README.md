# TapJump
A simple game of jumping to dodge falling items.

## Getting Started
This project is a starting point for a Flutter application.

This is my first game using the Flame game engine running in Flutter. The idea of the game is a game that I have previously released on iOS and Android.

For the physics engine, I'm using Forge2D, a port of Box2d, via flame_forge2d.

## Build and Run

### Preparation
Resolve all flutter errors.
```
flutter doctor
```

### Setting Flutter
Command + , to open the settings and write the path to the Flutter SDK including the version in "dart.flutterSdkPath" in Setting.json.(It is preferable to include it in the Setting.json of the workspace.)
```
"dart.flutterSdkPath": "/Users/[USER_NAME]/.asdf/installs/flutter/3.10.4",
"java.configuration.updateBuildConfiguration": "interactive",
"java.jdt.ls.java.home": "/Library/Java/JavaVirtualMachines/adoptopenjdk-17.0.8+101/Contents/Home"
```
Install the Flutter package.
```
flutter pub get
```
Restart VSCode.

### Install Cocoapods
In order to use libraries released by CocoaPods from Flutter, it is necessary to install CococaPods.
```
gem cleanup
brew uninstall cocoapods　<- Removed from brew
sudo gem uninstall cocoapods　<-　Removed from gem
sudo gem install cocoapods -v 1.11.0
```
I installed it with homebrew and asdf but it did not work, but installing from gem made it work.

### Launch flutter apps from vscode
Launch the iOS Simulator
```
open -a Simulator
```
In VSCode, open the command palette with "cmd + shift + p" and type "flutter:Select Device" to select the desired device.

### Reference materials

VSCodeからIOS Simulatorに接続する

https://massu-engineer.com/flutter-vscode-emulator/#VSCodeIOS_Simulator