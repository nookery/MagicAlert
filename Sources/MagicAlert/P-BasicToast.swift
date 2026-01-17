#if DEBUG
    import SwiftUI

    /// 基础样式预览
    private struct BasicToastPreview: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("基础样式")
                    .font(.headline)

                MagicToast(
                    message: "操作成功",
                    icon: "checkmark.circle",
                    style: .info
                )

                MagicToast(
                    message: "点击查看详情",
                    icon: "hand.tap",
                    style: .info
                )
            }
            .padding()
            .frame(width: 600)
            .frame(height: 600)
        }
    }

    #Preview("基础样式") {
        BasicToastPreview()
    }
#endif
