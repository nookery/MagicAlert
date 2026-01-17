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
    .package(url: "https://github.com/nookery/MagicAlert.git", from: "1.0.0")
]
```

Or add it directly in Xcode:

1. Go to File → Add Packages...
2. Enter the repository URL: `https://github.com/nookery/MagicAlert.git`
3. Choose the version you want to use

## Usage

Add the `.withMagicToast()` modifier to your root view and use `MagicMessageProvider.shared` to display messages:

```swift
import SwiftUI
import MagicAlert

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Success") {
                MagicMessageProvider.shared.success("Operation successful")
            }

            Button("Show Error") {
                MagicMessageProvider.shared.error("Operation failed")
            }

            Button("Show Info") {
                MagicMessageProvider.shared.info("This is an info message")
            }

            Button("Show Warning") {
                MagicMessageProvider.shared.warning("Please be careful")
            }

            Button("Show Loading") {
                MagicMessageProvider.shared.loading("Processing...")
            }
        }
        .withMagicToast() // Enable toast functionality
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
        MagicErrorView(error: error, title: "An error occurred")
    }
}
```

## Components

- `MagicMessageProvider` - Message provider for displaying various types of toasts
- `MagicErrorView` - Error display component

## Requirements

- iOS 17.0+
- macOS 14.0+
- Swift 5.9+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
