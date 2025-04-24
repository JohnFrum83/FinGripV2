import SwiftUI

struct FinancialScoreDetailsView: View {
    @ObservedObject var contentViewModel: ContentViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Overall Score Section
                    ScoreSection(score: contentViewModel.healthScore.overallScore)
                    
                    // Components Section
                    ComponentsSection(components: contentViewModel.healthScore.components)
                    
                    // Metrics Section
                    MetricsSection(healthScore: contentViewModel.healthScore)
                    
                    // Recommendations Section
                    RecommendationsSection(recommendations: contentViewModel.healthScore.recommendations)
                }
                .padding()
            }
            .navigationTitle("Financial Health Score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

struct ScoreSection: View {
    let score: Double
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Overall Financial Health")
                .font(.headline)
            
            AnimatedScoreView(score: score, size: 150, showLabel: true)
                .frame(width: 150, height: 150)
            
            Text(getScoreDescription(score))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func getScoreDescription(_ score: Double) -> String {
        switch score {
        case 90...100: return "Excellent"
        case 70..<90: return "Good"
        case 50..<70: return "Fair"
        default: return "Needs Improvement"
        }
    }
}

struct ComponentsSection: View {
    let components: [FinancialHealthScore.ScoreComponent]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contributing Factors")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(components, id: \.category) { component in
                    ScoreFactorRow(component: component)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}

struct ScoreFactorRow: View {
    let component: FinancialHealthScore.ScoreComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(component.category.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(component.score))")
                    .font(.headline)
                    .foregroundColor(scoreColor(component.score))
            }
            
            Text(component.details)
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: component.score, total: 100)
                .tint(scoreColor(component.score))
        }
    }
    
    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 0..<40: return .red
        case 40..<70: return .orange
        case 70..<90: return .yellow
        default: return .green
        }
    }
}

struct MetricsSection: View {
    let healthScore: FinancialHealthScore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Metrics")
                .font(.headline)
                .padding(.horizontal)
            
            MetricRow(
                title: "Savings Ratio",
                value: "\(Int(healthScore.savingsRatio * 100))%",
                icon: "banknote",
                color: .green
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct RecommendationsSection: View {
    let recommendations: [FinGripRecommendation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(recommendations) { recommendation in
                RecommendationRow(recommendation: recommendation)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RecommendationRow: View {
    let recommendation: FinGripRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: recommendation.type.icon)
                    .foregroundColor(recommendation.type.color)
                    .frame(width: 30)
                
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                ForEach(0..<impactStars(recommendation.impact), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            
            Text(recommendation.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private func impactStars(_ impact: FinGripRecommendation.Impact) -> Int {
        switch impact {
        case .significant: return 3
        case .moderate: return 2
        case .minimal: return 1
        }
    }
}

#Preview {
    FinancialScoreDetailsView(contentViewModel: ContentViewModel())
} 