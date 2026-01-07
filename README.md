# MagicAlert

[![中文](https://img.shields.io/badge/中文-README-blue)](README_zh.md)

A SwiftUI-based toast notification system for iOS and macOS applications.

## Features

- **Toast Notifications**: Display temporary messages to users
- **Multiple Toast Types**: Success, error, warning, and info toasts
- **Customizable Styling**: Easily customize appearance and behavior
- **Error Handling**: Built-in error view component
- **SwiftUI Native**: Fully built with SwiftUI for modern apps

## Installation

### Swift Package Manager

Add MagicAlert as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/MagicAlert.git", from: "1.0.0")
]
```

Or add it directly in Xcode:

1. Go to File → Add Packages...
2. Enter the repository URL: `https://github.com/yourusername/MagicAlert.git`
3. Choose the version you want to use

## Usage

### Basic Toast Usage

```swift
import SwiftUI
import MagicAlert

struct ContentView: View {
    @StateObject private var toastManager = MagicToastManager()

    var body: some View {
        ZStack {
            // Your main content here

            MagicToastContainer(toastManager: toastManager)
        }
        .onAppear {
            // Show a success toast
            toastManager.showToast(
                message: "Operation completed successfully!",
                type: .success,
                duration: 3.0
            )
        }
    }
}
```

### Toast Types

- `.success` - Green success notification
- `.error` - Red error notification
- `.warning` - Orange warning notification
- `.info` - Blue information notification

### Error Display

```swift
import SwiftUI
import MagicAlert

struct ErrorView: View {
    let error: Error

    var body: some View {
        error.makeView(title: "An error occurred")
    }
}
```

## Components

- `MagicToastManager` - Manages toast notifications
- `MagicToastContainer` - Container view for displaying toasts
- `MagicToast` - Individual toast view
- `MagicErrorView` - Error display component
- `MagicToastType` - Toast type enumeration

## Requirements

- iOS 17.0+
- macOS 14.0+
- Swift 5.9+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
