import SwiftUI

struct AnimatedScoreView: View {
    let score: Double
    let size: CGFloat
    let showLabel: Bool
    
    private var progress: Double {
        score / 100.0
    }
    
    private var scoreColor: Color {
        switch score {
        case 0..<40: return .red
        case 40..<70: return .orange
        case 70..<90: return .yellow
        default: return .green
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.2)
                .foregroundColor(scoreColor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(scoreColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: progress)
                .accessibilityLabel("Score progress: \(Int(score)) percent")
            
            if showLabel {
                VStack(spacing: 4) {
                    Text("\(Int(score))")
                        .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                    Text("Score")
                        .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
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