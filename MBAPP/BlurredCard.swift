import SwiftUI

struct BlurredCard: View {
    let content: AnyView
    
    var body: some View {
        content
            .padding()
            .background(
                BlurView(style: .systemMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .padding()
    }
}
