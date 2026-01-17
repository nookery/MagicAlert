import SwiftUI

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

/// 用于展示详细错误信息的视图组件
public struct MagicErrorView: View {
    let error: Error
    let title: String?
    let onDismiss: (() -> Void)?
    @State private var isExpanded = false

    public init(error: Error, title: String? = nil, onDismiss: (() -> Void)? = nil) {
        self.error = error
        self.title = title
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 错误图标和标题
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.title2)

                Text(title ?? "错误详情")
                    .font(.headline)

                Spacer()

                // 操作按钮组
                ErrorViewActionButtons(error: error, onDismiss: onDismiss)
            }

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // 错误描述
                    ErrorSection(title: "错误描述", content: error.localizedDescription)

                    // 失败原因
                    if let failureReason = (error as? LocalizedError)?.failureReason {
                        ErrorSection(title: "失败原因", content: failureReason)
                    }

                    // 恢复建议
                    if let recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion {
                        ErrorSection(title: "恢复建议", content: recoverySuggestion)
                    }

                    // NSError 详细信息
                    let nsError = error as NSError
                    // 错误域和代码
                    if nsError.domain != "NSCocoaErrorDomain" || nsError.code != 0 {
                        ErrorSection(title: "错误信息", content: "域: \(nsError.domain)\n代码: \(nsError.code)")
                    }

                    // 帮助信息
                    if let helpAnchor = nsError.helpAnchor, !helpAnchor.isEmpty {
                        ErrorSection(title: "帮助信息", content: helpAnchor)
                    }

                    // 底层错误
                    if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                        ErrorSection(title: "底层错误", content: underlyingError.localizedDescription)
                    }

                    // 调试信息（仅在DEBUG模式下显示）
                    #if DEBUG
                        if let debugInfo = getDebugInfo() {
                            DisclosureGroup(
                                isExpanded: $isExpanded,
                                content: {
                                    Text(debugInfo)
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                        .textSelection(.enabled)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                },
                                label: {
                                    Label("调试信息", systemImage: "ladybug")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            )
                            .padding(.top, 8)
                        }
                    #endif
                }
            }
        }
        .padding(20)
        .frame(minWidth: 300)
        #if os(iOS)
            .frame(maxWidth: min(700, UIScreen.main.bounds.width * 0.9))
            .frame(idealWidth: min(500, UIScreen.main.bounds.width * 0.8))
        #elseif os(macOS)
            .frame(maxWidth: 700)
            .frame(idealWidth: 500)
        #endif
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.red.opacity(0.03))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.red.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    private func getDebugInfo() -> String? {
        #if DEBUG
            var debugInfo: [String] = []

            // 完整的错误描述
            debugInfo.append("完整错误: \(error)")

            // 调试描述（如果可用）
            let debugDescription = String(reflecting: error)
            let errorDescription = "\(error)"
            if debugDescription != errorDescription && !debugDescription.isEmpty {
                debugInfo.append("调试描述: \(debugDescription)")
            }

            // NSError 的用户信息
            let nsError = error as NSError
            if !nsError.userInfo.isEmpty {
                debugInfo.append("用户信息: \(nsError.userInfo)")
            }

            return debugInfo.isEmpty ? nil : debugInfo.joined(separator: "\n\n")
        #else
            return nil
        #endif
    }
}

/// 错误信息区域组件
private struct ErrorSection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
    #Preview {
        MagicToastExampleView()
            .withMagicToast()
            .frame(width: 400, height: 600)
    }
#endif
