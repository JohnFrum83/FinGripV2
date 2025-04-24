import SwiftUI
import Charts

struct FinancialHealthView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @State private var selectedTimeRange = TimeRange.month
    @State private var showingRecommendationDetails = false
    @State private var selectedRecommendation: FinGripRecommendation?
    
    private let scoreGradient = LinearGradient(
        colors: [.red, .orange, .yellow, .green],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Score Overview
                scoreCard
                
                // Category Scores
                categoryScoresSection
                
                // Key Metrics
                keyMetricsSection
                
                // Recommendations
                recommendationsSection
                
                // Historical Progress
                historicalProgressSection
            }
            .padding()
        }
        .navigationTitle("Financial Health")
        .sheet(isPresented: $showingRecommendationDetails) {
            if let recommendation = selectedRecommendation {
                RecommendationDetailView(recommendation: recommendation)
            }
        }
    }
    
    private var scoreCard: some View {
        VStack(spacing: 15) {
            AnimatedScoreView(score: contentViewModel.healthScore.overallScore, size: 150, showLabel: true)
                .frame(width: 150, height: 150)
            
            Text(scoreLabel)
                .font(.title3)
                .foregroundColor(.secondary)
            
            ScoreGauge(score: Int(contentViewModel.healthScore.overallScore))
                .frame(height: 15)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var categoryScoresSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Category Scores")
                .font(.headline)
            
            ForEach(FinancialCategory.allCases, id: \.self) { category in
                if let score = contentViewModel.healthScore.components.first(where: { $0.category.rawValue == category.rawValue })?.score {
                    CategoryScoreRow(
                        category: category,
                        score: score
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var keyMetricsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Key Metrics")
                .font(.headline)
            
            MetricRow(
                title: "Savings Ratio",
                value: "\(Int(contentViewModel.healthScore.savingsRatio * 100))%",
                icon: "banknote",
                color: Color.blue
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recommendations")
                .font(.headline)
            
            ForEach(contentViewModel.healthScore.recommendations) { recommendation in
                RecommendationCard(recommendation: recommendation)
                    .onTapGesture {
                        selectedRecommendation = recommendation
                        showingRecommendationDetails = true
                    }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var historicalProgressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Score History")
                .font(.headline)
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(TimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            
            ScoreHistoryChart(data: contentViewModel.scoreHistory.map { ($0.date, Int($0.overallScore)) })
                .frame(height: 200)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var scoreColor: Color {
        let score = Int(contentViewModel.healthScore.overallScore)
        switch score {
        case 0...40: return .red
        case 41...60: return .orange
        case 61...80: return .yellow
        default: return .green
        }
    }
    
    private var scoreLabel: String {
        let score = Int(contentViewModel.healthScore.overallScore)
        switch score {
        case 0...40: return "Needs Improvement"
        case 41...60: return "Fair"
        case 61...80: return "Good"
        default: return "Excellent"
        }
    }
}

// MARK: - Supporting Views

struct ScoreGauge: View {
    let score: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(.systemGray5))
                
                Rectangle()
                    .fill(gaugeGradient)
                    .frame(width: geometry.size.width * CGFloat(score) / 100)
            }
            .cornerRadius(5)
        }
    }
    
    private var gaugeGradient: LinearGradient {
        LinearGradient(
            colors: [.red, .orange, .yellow, .green],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct CategoryScoreRow: View {
    let category: FinancialCategory
    let score: Double
    
    var body: some View {
        HStack {
            Text(category.rawValue)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(Int(score))")
                .bold()
        }
    }
}

struct ScoreHistoryChart: View {
    let data: [(Date, Int)]
    
    var body: some View {
        Chart(data, id: \.0) { date, score in
            LineMark(
                x: .value("Date", date),
                y: .value("Score", score)
            )
            .foregroundStyle(Color.blue.gradient)
            
            AreaMark(
                x: .value("Date", date),
                y: .value("Score", score)
            )
            .foregroundStyle(Color.blue.opacity(0.1))
        }
        .chartYScale(domain: 0...100)
    }
}

struct RecommendationCard: View {
    let recommendation: FinGripRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: recommendation.type.icon)
                    .font(.title2)
                    .foregroundColor(recommendation.type.color)
                
                Text(recommendation.title)
                    .font(.headline)
            }
            
            Text(recommendation.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(0..<recommendation.impact.starCount, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

extension FinGripRecommendation.Impact {
    var starCount: Int {
        switch self {
        case .significant: return 3
        case .moderate: return 2
        case .minimal: return 1
        }
    }
}

struct RecommendationDetailView: View {
    let recommendation: FinGripRecommendation
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Icon and Title
                    HStack {
                        Image(systemName: recommendation.type.icon)
                            .font(.largeTitle)
                            .foregroundColor(recommendation.type.color)
                        
                        Text(recommendation.title)
                            .font(.title)
                            .bold()
                    }
                    
                    // Impact Level
                    HStack {
                        Text("Impact")
                            .font(.headline)
                        
                        Spacer()
                        
                        ForEach(0..<recommendation.impact.starCount, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // Description
                    Text(recommendation.description)
                        .font(.body)
                    
                    // Action Steps
                    actionSteps
                    
                    // Benefits
                    benefits
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var actionSteps: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Action Steps")
                .font(.headline)
            
            ForEach(getActionSteps(), id: \.self) { step in
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text(step)
                }
            }
        }
    }
    
    private var benefits: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Benefits")
                .font(.headline)
            
            ForEach(getBenefits(), id: \.self) { benefit in
                HStack(alignment: .top) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                    Text(benefit)
                }
            }
        }
    }
    
    private func getActionSteps() -> [String] {
        switch recommendation.type {
        case .saving:
            return [
                "Set up automatic transfers to savings",
                "Review and cut unnecessary expenses",
                "Look for additional income opportunities"
            ]
        case .debt:
            return [
                "List all debts and their interest rates",
                "Consider debt consolidation",
                "Create a debt repayment plan"
            ]
        case .spending:
            return [
                "Track all expenses for a month",
                "Identify spending patterns",
                "Create a realistic budget"
            ]
        case .income:
            return [
                "Update your skills",
                "Look for promotion opportunities",
                "Consider side hustles"
            ]
        case .investment:
            return [
                "Research investment options",
                "Start with low-risk investments",
                "Consider consulting a financial advisor"
            ]
        case .budgeting:
            return [
                "Track all expenses for a month",
                "Identify spending patterns",
                "Create a realistic budget"
            ]
        }
    }
    
    private func getBenefits() -> [String] {
        switch recommendation.type {
        case .saving:
            return [
                "Increased financial security",
                "Better preparedness for emergencies",
                "Progress toward financial goals"
            ]
        case .debt:
            return [
                "Reduced interest payments",
                "Improved credit score",
                "Less financial stress"
            ]
        case .spending:
            return [
                "Better control over finances",
                "More money for important goals",
                "Reduced wasteful spending"
            ]
        case .income:
            return [
                "Increased earning potential",
                "Better career opportunities",
                "More financial flexibility"
            ]
        case .investment:
            return [
                "Long-term wealth building",
                "Potential passive income",
                "Portfolio diversification"
            ]
        case .budgeting:
            return [
                "Better control over finances",
                "More money for important goals",
                "Reduced wasteful spending"
            ]
        }
    }
}

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    
    var id: String { rawValue }
}

#Preview {
    NavigationView {
        FinancialHealthView()
            .environmentObject(ContentViewModel())
    }
} 