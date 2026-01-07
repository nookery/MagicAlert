# MagicAlert

[![English](https://img.shields.io/badge/English-README-green)](README.md)

一个基于SwiftUI的iOS和macOS应用吐司通知系统。

## 功能特性

- **吐司通知**: 向用户显示临时消息
- **多种吐司类型**: 成功、错误、警告和信息吐司
- **可自定义样式**: 轻松自定义外观和行为
- **错误处理**: 内置错误视图组件
- **原生SwiftUI**: 完全使用SwiftUI构建，适用于现代应用

## 安装

### Swift Package Manager

将MagicAlert作为依赖项添加到您的`Package.swift`中：

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/MagicAlert.git", from: "1.0.0")
]
```

或者直接在Xcode中添加：

1. 转到文件 → 添加包...
2. 输入仓库URL：`https://github.com/yourusername/MagicAlert.git`
3. 选择您要使用的版本

## 使用方法

### 基本吐司使用

```swift
import SwiftUI
import MagicAlert

struct ContentView: View {
    @StateObject private var toastManager = MagicToastManager()

    var body: some View {
        ZStack {
            // 您的主要内容在这里

            MagicToastContainer(toastManager: toastManager)
        }
        .onAppear {
            // 显示成功吐司
            toastManager.showToast(
                message: "操作成功完成！",
                type: .success,
                duration: 3.0
            )
        }
    }
}
```

### 吐司类型

- `.success` - 绿色成功通知
- `.error` - 红色错误通知
- `.warning` - 橙色警告通知
- `.info` - 蓝色信息通知

### 错误显示

```swift
import SwiftUI
import MagicAlert

struct ErrorView: View {
    let error: Error

    var body: some View {
        error.makeView(title: "发生错误")
    }
}
```

## 组件

- `MagicToastManager` - 管理吐司通知
- `MagicToastContainer` - 显示吐司的容器视图
- `MagicToast` - 单个吐司视图
- `MagicErrorView` - 错误显示组件
- `MagicToastType` - 吐司类型枚举

## 要求

- iOS 17.0+
- macOS 14.0+
- Swift 5.9+

## 许可证

本项目采用MIT许可证 - 详见LICENSE文件。
