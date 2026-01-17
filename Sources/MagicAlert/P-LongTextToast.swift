#if DEBUG
    import SwiftUI

    /// 长文本预览
    private struct LongTextToastPreview: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("长文本")
                    .font(.headline)

                Toast(
                    message: "这是一条比较长的提示信息，用来测试 Toast 的自适应宽度和换行效果",
                    icon: "text.bubble",
                    style: .info
                )

                Toast(
                    message: "Another long message in English to test the text wrapping and adaptive width of the toast",
                    icon: "text.bubble",
                    style: .info
                )
            }
            .padding()
            .frame(width: 600)
            .frame(height: 600)
        }
    }

    #Preview("长文本") {
        LongTextToastPreview()
    }
#endif
