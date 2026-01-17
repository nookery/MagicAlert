import SwiftUI

/// 错误视图的操作按钮组
struct ErrorViewActionButtons: View {
    let error: Error
    let onDismiss: (() -> Void)?

    @State private var showCopied = false
    @State private var isCloseButtonHovered = false

    var body: some View {
        HStack(spacing: 8) {
            // 复制按钮
            Button {
                copyErrorInfo()
            } label: {
                Image(systemName: showCopied ? "checkmark.circle.fill" : "doc.on.doc")
                    .foregroundStyle(showCopied ? .green : .blue)
                    .animation(.default, value: showCopied)
            }
            .buttonStyle(.borderless)

            // 关闭按钮（如果提供了 onDismiss）
            if let onDismiss = onDismiss {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(isCloseButtonHovered ? .red : .red.opacity(0.8))
                        .font(.title)
                }
                .buttonStyle(.borderless)
                .help("关闭错误详情")
                .scaleEffect(isCloseButtonHovered ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isCloseButtonHovered)
                .onHover { hovering in
                    isCloseButtonHovered = hovering
                }
            }
        }
    }

    private func copyErrorInfo() {
        var errorInfo = [String]()

        errorInfo.append("错误描述：\n\(error.localizedDescription)")

        if let failureReason = (error as? LocalizedError)?.failureReason {
            errorInfo.append("\n失败原因：\n\(failureReason)")
        }

        if let recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion {
            errorInfo.append("\n恢复建议：\n\(recoverySuggestion)")
        }

        // 添加 NSError 信息
        let nsError = error as NSError
        if nsError.domain != "NSCocoaErrorDomain" || nsError.code != 0 {
            errorInfo.append("\n错误信息：\n域: \(nsError.domain)\n代码: \(nsError.code)")
        }

        if let helpAnchor = nsError.helpAnchor, !helpAnchor.isEmpty {
            errorInfo.append("\n帮助信息：\n\(helpAnchor)")
        }

        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            errorInfo.append("\n底层错误：\n\(underlyingError.localizedDescription)")
        }

        let fullErrorInfo = errorInfo.joined(separator: "\n")

        // 复制到系统粘贴板
        #if os(iOS)
            UIPasteboard.general.string = fullErrorInfo
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(fullErrorInfo, forType: .string)
        #endif

        showCopied = true

        // 2秒后重置复制状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopied = false
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
