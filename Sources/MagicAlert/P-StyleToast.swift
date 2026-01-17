#if DEBUG
    import SwiftUI

    /// 不同样式预览
    private struct StyleToastPreview: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("不同样式")
                    .font(.headline)

                Group {
                    Text("信息").font(.subheadline)
                    MagicToast(
                        message: "这是一条提示信息",
                        icon: "info.circle",
                        style: .info
                    )
                }

                Group {
                    Text("警告").font(.subheadline)
                    MagicToast(
                        message: "请注意这个警告",
                        icon: "exclamationmark.triangle",
                        style: .warning
                    )
                }

                Group {
                    Text("错误").font(.subheadline)
                    MagicToast(
                        message: "出现了一个错误",
                        icon: "xmark.circle",
                        style: .error
                    )
                }
            }
            .padding()
            .frame(width: 600)
            .frame(height: 800)
        }
    }

    #Preview("不同样式") {
        StyleToastPreview()
    }
#endif
