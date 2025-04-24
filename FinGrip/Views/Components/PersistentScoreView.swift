import SwiftUI

struct PersistentScoreViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

struct PersistentScoreView: View {
    @StateObject private var viewModel: PersistentScoreViewModel
    @State private var isDragging = false
    @State private var position: CGPoint
    @State private var showDetails = false
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    private let size: CGFloat = 50
    private let edgeInset: CGFloat = 20
    
    init(score: Double, onScoreUpdate: @escaping (Double) -> Void) {
        let viewModel = PersistentScoreViewModel(score: score, onScoreUpdate: onScoreUpdate)
        _viewModel = StateObject(wrappedValue: viewModel)
        
        // Initialize position on the right side of the screen
        let screenWidth = UIScreen.main.bounds.width
        _position = State(initialValue: CGPoint(x: screenWidth - 80, y: 100))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main score view
                AnimatedScoreView(score: viewModel.score, size: size, showLabel: false)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .shadow(radius: isDragging ? 8 : 4)
                    )
                    .offset(x: dragOffset.width, y: dragOffset.height)
                    .position(position)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onChanged { _ in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isDragging = true
                                }
                            }
                            .onEnded { value in
                                let newPosition = calculateNewPosition(
                                    from: position,
                                    translation: value.translation,
                                    in: geometry.size
                                )
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    position = newPosition
                                    isDragging = false
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDetails.toggle()
                        }
                    }
                
                // Score details sheet
                .sheet(isPresented: $showDetails) {
                    FinancialScoreDetailsView(contentViewModel: contentViewModel)
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .preference(key: PersistentScoreViewPreferenceKey.self, value: position)
        .ignoresSafeArea()
    }
    
    private func calculateNewPosition(from currentPosition: CGPoint, translation: CGSize, in size: CGSize) -> CGPoint {
        var newPosition = CGPoint(
            x: currentPosition.x + translation.width,
            y: currentPosition.y + translation.height
        )
        
        // Keep within screen bounds with edge insets
        newPosition.x = min(max(edgeInset + self.size/2, newPosition.x), size.width - edgeInset - self.size/2)
        newPosition.y = min(max(edgeInset + self.size/2, newPosition.y), size.height - edgeInset - self.size/2)
        
        return newPosition
    }
}

@MainActor
final class PersistentScoreViewModel: ObservableObject {
    @Published var score: Double
    private let onScoreUpdate: (Double) -> Void
    
    init(score: Double, onScoreUpdate: @escaping (Double) -> Void) {
        self.score = score
        self.onScoreUpdate = onScoreUpdate
    }
    
    func updateScore(_ newScore: Double) {
        score = newScore
        onScoreUpdate(newScore)
    }
}

#Preview {
    PersistentScoreView(score: 75.0) { _ in }
} 