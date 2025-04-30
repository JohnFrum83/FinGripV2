import SwiftUI

struct AnimatedScoreView: View {
    let score: Double
    let size: CGFloat
    let showLabel: Bool
    
    private var progress: Double {
        score / 100.0
    }
    
    private let gradient = AngularGradient(
        stops: [
            .init(color: .red, location: 0.0),
            .init(color: .orange, location: 0.33),
            .init(color: .yellow, location: 0.66),
            .init(color: .green, location: 1.0)
        ],
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(360)
    )
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.1)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .fill(gradient)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
                .accessibilityLabel("Score progress: \(Int(score)) percent")
            
            if showLabel {
                VStack(spacing: 4) {
                    Text("\(Int(score))")
                        .font(.system(size: size * 0.3, weight: .bold, design: .rounded))
                    Text("Financial Score")
                        .font(.system(size: size * 0.11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            } else {
                Text("\(Int(score))")
                    .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    VStack(spacing: 20) {
        AnimatedScoreView(score: 85, size: 200, showLabel: true)
        AnimatedScoreView(score: 45, size: 100, showLabel: false)
    }
    .padding()
} 