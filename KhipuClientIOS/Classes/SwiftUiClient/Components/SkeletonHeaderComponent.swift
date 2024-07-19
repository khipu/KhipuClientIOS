import SwiftUI

@available(iOS 15.0, *)
struct SkeletonHeaderComponent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .cornerRadius(4)
                    .shimmer()

                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 12)
                        .cornerRadius(4)
                        .shimmer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 12)
                        .cornerRadius(4)
                        .shimmer()
                }

                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 12)
                        .cornerRadius(4)
                        .shimmer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 16)
                        .cornerRadius(4)
                        .shimmer()
                }
            }

            Divider()
                .background(Color.gray.opacity(0.3))
                .shimmer()

            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 186, height: 16)
                    .cornerRadius(4)
                    .shimmer()
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 16)
                    .cornerRadius(4)
                    .shimmer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4) 
    }
}

@available(iOS 15.0, *)
struct ShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.gray.opacity(0.3), location: 0.0),
                        .init(color: Color.gray.opacity(0.1), location: 0.5),
                        .init(color: Color.gray.opacity(0.3), location: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.5),
                                    .init(color: .clear, location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(-30))
                        .offset(x: phase * 300, y: 0)
                )
                .animation(
                    Animation.linear(duration: 1.0)
                        .repeatForever(autoreverses: false)
                )
            )
            .onAppear {
                withAnimation {
                    phase = 1
                }
            }
    }
}

@available(iOS 15.0, *)
extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerViewModifier())
    }
}

@available(iOS 15.0, *)
struct SkeletonHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        return SkeletonHeaderComponent()
    }
}
