import SwiftUI

/// 单个Toast视图
struct ToastView: View {
    let toast: MagicToastModel
    let onDismiss: (UUID) -> Void

    @State private var progress: Double = 1.0
    @State private var isVisible = false
    @State private var dragOffset = CGSize.zero

    var body: some View {
        // 根据类型显示不同的视图
        if case .errorDetail = toast.type {
            errorDetailView
        } else {
            standardToastView
        }
    }

    // 标准Toast视图
    private var standardToastView: some View {
        VStack(spacing: 16) {
            // 图标
            Group {
                if case .loading = toast.type {
                    // 加载动画
                    Image(systemName: toast.type.systemImage)
                        .foregroundColor(toast.type.color)
                        .rotationEffect(.degrees(isVisible ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isVisible)
                } else {
                    // 静态图标
                    Image(systemName: toast.type.systemImage)
                        .foregroundColor(toast.type.color)
                }
            }
            .font(.system(size: 64))
            .frame(width: 72, height: 72)

            // 内容
            VStack(spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                if let subtitle = toast.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(width: 180, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 0.95 : 0.0)
        .offset(y: dragOffset.height)
        .gesture(
            toast.tapToDismiss ?
                DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    if abs(value.translation.height) > 50 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            onDismiss(toast.id)
                        }
                    } else {
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
                }
                : nil
        )
        .onTapGesture {
            if toast.tapToDismiss {
                toast.onTap?()
                withAnimation(.easeInOut(duration: 0.3)) {
                    onDismiss(toast.id)
                }
            } else {
                toast.onTap?()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }

            // 进度条动画
            if toast.autoDismiss && toast.duration > 0 {
                withAnimation(.linear(duration: toast.duration)) {
                    progress = 0.0
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            // 关闭按钮（仅在不自动消失时显示）
            if !toast.autoDismiss {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onDismiss(toast.id)
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(8)
                .contentShape(Rectangle())
            }
        }
        .overlay(alignment: .bottom) {
            // 进度条
            if toast.showProgress && toast.autoDismiss && toast.duration > 0 {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(toast.type.color)
                        .frame(width: geometry.size.width * progress, height: 2)
                        .animation(.linear(duration: toast.duration), value: progress)
                }
                .frame(height: 2)
            }
        }
    }

    // 错误详情视图
    private var errorDetailView: some View {
        Group {
            if case let .errorDetail(error, title) = toast.type {
                VStack(alignment: .leading, spacing: 16) {
                    // 错误图标和标题
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.title2)

                        Text(title)
                            .font(.headline)

                        Spacer()

                        // 复制按钮
                        Button {
                            copyErrorInfo(error)
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.borderless)

                        // 关闭按钮
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                onDismiss(toast.id)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red.opacity(0.8))
                                .font(.title)
                        }
                        .buttonStyle(.borderless)
                        .help("关闭错误详情")
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
                            if let nsError = error as? NSError {
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
                            }
                        }
                    }
                }
                .padding(20)
                .frame(minWidth: 300, maxWidth: 700)
                .frame(idealWidth: 500)
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
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isVisible = true
                    }
                }
            }
        }
    }
}

private func copyErrorInfo(_ error: Error) {
    var errorInfo = [String]()

    errorInfo.append("错误描述：\n\(error.localizedDescription)")

    if let failureReason = (error as? LocalizedError)?.failureReason {
        errorInfo.append("\n失败原因：\n\(failureReason)")
    }

    if let recoverySuggestion = (error as? LocalizedError)?.recoverySuggestion {
        errorInfo.append("\n恢复建议：\n\(recoverySuggestion)")
    }

    // 添加 NSError 信息
    if let nsError = error as? NSError {
        if nsError.domain != "NSCocoaErrorDomain" || nsError.code != 0 {
            errorInfo.append("\n错误信息：\n域: \(nsError.domain)\n代码: \(nsError.code)")
        }

        if let helpAnchor = nsError.helpAnchor, !helpAnchor.isEmpty {
            errorInfo.append("\n帮助信息：\n\(helpAnchor)")
        }

        if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            errorInfo.append("\n底层错误：\n\(underlyingError.localizedDescription)")
        }
    }

    let fullErrorInfo = errorInfo.joined(separator: "\n")

    // 复制到系统粘贴板
    #if os(iOS)
        UIPasteboard.general.string = fullErrorInfo
    #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(fullErrorInfo, forType: .string)
    #endif
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
