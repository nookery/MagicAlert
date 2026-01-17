import SwiftUI

/// Toast容器视图
struct ToastContainer: View {
    @ObservedObject var toastManager: MagicToastManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 普通Toast视图
                ForEach(toastManager.toasts.filter { !isErrorDetailToast($0) }) { toast in
                    ToastView(toast: toast, onDismiss: toastManager.dismiss)
                        .padding(.horizontal, 16)
                        .positioned(for: toast.displayMode, in: geometry)
                }

                // 错误详情视图
                ForEach(toastManager.toasts.filter { isErrorDetailToast($0) }, id: \.id) { toast in
                    if case let .errorDetail(error, title) = toast.type {
                        MagicErrorView(
                            error: error,
                            title: title,
                            onDismiss: {
                                toastManager.dismiss(toast.id)
                            }
                        )
                        .frame(width: geometry.size.width * 0.8)
                        .frame(height: geometry.size.height * 0.8)
                        .positioned(for: toast.displayMode, in: geometry)
                    }
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: toastManager.toasts)
        }
    }

    private func isErrorDetailToast(_ toast: MagicToastModel) -> Bool {
        if case .errorDetail = toast.type {
            return true
        }
        return false
    }
}

// MARK: - Position Extension

extension View {
    @ViewBuilder
    func positioned(for displayMode: MagicToastDisplayMode, in geometry: GeometryProxy) -> some View {
        switch displayMode {
        case .overlay:
            self
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

        case .banner:
            VStack {
                self
                Spacer()
            }
            .padding(.top, 60)

        case .bottom:
            VStack {
                Spacer()
                self
            }
            .padding(.bottom, 40)

        case .corner:
            VStack {
                HStack {
                    Spacer()
                    self
                }
                Spacer()
            }
            .padding(.top, 60)
            .padding(.trailing, 20)
        }
    }
}

#if DEBUG
    #Preview {
        MagicToastExampleView()
            .frame(width: 600, height: 600)
            .withMagicToast()
    }
#endif
