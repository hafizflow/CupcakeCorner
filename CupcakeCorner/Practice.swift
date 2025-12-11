import SwiftUI


struct Practice: View {
    @State private var count: Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text(String(count)).contentTransition(.numericText()).font(.title)
            Button("Haptic FeedBack") {
                withAnimation {
                    count += 1
                }
            }
            .sensoryFeedback(.warning, trigger: count)
        }
    }
}

#Preview {
    Practice()
}
