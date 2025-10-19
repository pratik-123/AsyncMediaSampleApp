# AsyncMediaSampleApp

AsyncMediaSampleApp is a SwiftUI demonstration app for building an **interactive image list** with **tappable markers** that play mini-videos using `AVPlayer` and SwiftUI's `VideoPlayer`.

## Features

- **Display a list of images** loaded asynchronously.
- **Add markers**: Tap anywhere on an image to drop a red marker.
- **Interactive mini video player**: Tap a marker to overlay an AVPlayer mini-video at marker location.
- **Animated marker placement** and video overlay logic.
- **Clean SwiftUI + MVVM architecture**.

## Getting Started

1. **Clone this repo:**
git clone https://github.com/pratik-123/AsyncMediaSampleApp.git

2. **Open AsyncMediaSampleApp.xcodeproj in Xcode.**
3. **Build and run on Simulator or Device**.

## Usage

- Tap anywhere on an image to place a red marker.
- Tap a marker to show a mini video overlay (AVPlayer).

## Code Highlights

- `ImageRowView`: Manages display, interaction, marker logic, and video overlay.
- `MiniVideoPlayerView`: Custom-styled mini video overlay.
- **MVVM pattern** for marker state/control.

## Author

[Pratik-123](https://github.com/pratik-123)

![alt tag](https://github.com/pratik-123/AsyncMediaSampleApp/blob/main/ScreenShot.png)
