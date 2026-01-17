#if DEBUG
    import SwiftUI

    /// 动画效果预览
    private struct AnimationToastPreview: View {
        @State private var showToast = false

        var body: some View {
            VStack(spacing: 20) {
                Text("动画效果")
                    .font(.headline)

                Button("显示/隐藏 Toast") {
                    withAnimation {
                        showToast.toggle()
                    }
                }

                if showToast {
                    Group {
                        MagicToast(
                            message: "信息提示动画",
                            icon: "info.circle",
                            style: .info
                        )

                        MagicToast(
                            message: "警告提示动画",
                            icon: "exclamationmark.triangle",
                            style: .warning
                        )

                        MagicToast(
                            message: "错误提示动画",
                            icon: "xmark.circle",
                            style: .error
                        )
                    }
                }
            }
            .padding()
            .frame(width: 600)
            .frame(height: 600)
        }
    }

    #Preview("动画效果") {
        AnimationToastPreview()
    }
#endif
