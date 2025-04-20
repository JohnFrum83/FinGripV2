import SwiftUI

/// A detailed view that displays the user's financial score and its components.
/// This view provides a comprehensive breakdown of:
/// - Overall financial health score
/// - Individual category scores (savings, debt, spending, etc.)
/// - Progress indicators for each category
/// - Recommendations for improvement
///
/// The view uses a combination of charts, progress indicators, and detailed
/// explanations to help users understand their financial standing and areas
/// for improvement.
struct ScoreDetailsView: View {
    /// The user's overall financial score
    let score: Int
    
    /// Detailed scores for each financial category
    let categoryScores: [FinancialCategory: Int]
    
    /// Recommendations for improving the score
    let recommendations: [String]
    
    var body: some View {
        List {
            ForEach(FinancialCategory.allCases, id: \.self) { category in
                HStack {
                    Text(category.displayName)
                    Spacer()
                    Text("\(categoryScores[category] ?? 0)")
                        .foregroundColor(category.color)
                }
            }
        }
        .navigationTitle(LocalizationKey.scoreDetails.localized)
    }
    
    /// Section displaying the overall score and its interpretation
    private var scoreOverviewSection: some View {
        VStack(spacing: 10) {
            Text("\(score)/100")
                .font(.system(size: 48, weight: .bold))
            
            Text(scoreInterpretation)
                .font(.headline)
                .foregroundColor(.secondary)
            
            ProgressView(value: Double(score), total: 100)
                .progressViewStyle(.linear)
                .tint(scoreColor)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Section displaying recommendations for improving the score
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(LocalizationKey.scoreRecommendations.localized)
                .font(.headline)
            
            ForEach(recommendations, id: \.self) { recommendation in
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(recommendation)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Computed property for the score's color based on its value
    private var scoreColor: Color {
        switch score {
        case 0...40: return .red
        case 41...70: return .orange
        case 71...90: return .green
        default: return .blue
        }
    }
    
    /// Computed property for the score's interpretation text
    private var scoreInterpretation: String {
        switch score {
        case 0...40: return LocalizationKey.scoreNeedsImprovement.localized
        case 41...70: return LocalizationKey.scoreFair.localized
        case 71...90: return LocalizationKey.scoreGood.localized
        default: return LocalizationKey.scoreExcellent.localized
        }
    }
    
    /// Returns the appropriate color for a given financial category
    private func categoryColor(for category: FinancialCategory) -> Color {
        category.color
    }
}

/// Preview provider for ScoreDetailsView
#Preview {
    NavigationView {
        ScoreDetailsView(
            score: 75,
            categoryScores: [
                FinancialCategory.savings: 80,
                FinancialCategory.debt: 70,
                FinancialCategory.spending: 65,
                FinancialCategory.income: 85
            ],
            recommendations: [
                "Increase your emergency fund to 3 months of expenses",
                "Consider consolidating high-interest debt",
                "Review your monthly subscriptions for potential savings"
            ]
        )
    }
} 