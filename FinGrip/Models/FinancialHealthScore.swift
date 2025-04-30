import Foundation
import SwiftUI

struct FinancialHealthScore: Codable {
    var date: Date
    var overallScore: Double
    var components: [ScoreComponent]
    var categoryScores: [Category: Double]
    var savingsRatio: Double
    var trend: Double
    var recommendations: [FinGripRecommendation]
    
    init(date: Date = Date(), components: [ScoreComponent] = []) {
        self.date = date
        self.components = components
        self.overallScore = Self.calculateOverallScore(from: components)
        self.categoryScores = Dictionary(uniqueKeysWithValues: components.map { ($0.category, $0.score) })
        self.savingsRatio = 0.0
        self.trend = 0.0
        self.recommendations = []
    }
    
    struct ScoreComponent: Codable {
        var category: Category
        var score: Double
        var details: String
        
        init(category: Category, score: Double, details: String) {
            self.category = category
            self.score = score
            self.details = details
        }
    }
    
    enum Category: String, Codable, CaseIterable {
        case savings
        case debt
        case spending
        case investments
        case protection
        
        var description: String {
            switch self {
            case .savings: return "Savings & Emergency Fund"
            case .debt: return "Debt Management"
            case .spending: return "Spending Habits"
            case .investments: return "Investment Strategy"
            case .protection: return "Financial Protection"
            }
        }
        
        var icon: String {
            switch self {
            case .savings: return "banknote"
            case .debt: return "creditcard"
            case .spending: return "cart"
            case .investments: return "chart.line.uptrend.xyaxis"
            case .protection: return "shield"
            }
        }
    }
    
    private static func calculateOverallScore(from components: [ScoreComponent]) -> Double {
        guard !components.isEmpty else { return 0 }
        let totalScore = components.reduce(0) { $0 + $1.score }
        return totalScore / Double(components.count)
    }
    
    func getScoreColor() -> Color {
        switch overallScore {
        case 0..<50: return Color.red
        case 50..<70: return Color.orange
        case 70..<85: return Color.green
        default: return Color.blue
        }
    }
    
    func getScoreDescription() -> String {
        switch overallScore {
        case 0..<50: return "Needs Attention"
        case 50..<70: return "Fair"
        case 70..<85: return "Good"
        default: return "Excellent"
        }
    }
    
    /// Initialize with default values for testing
    static var preview: FinancialHealthScore {
        var score = FinancialHealthScore(
            date: Date(),
            components: [
                ScoreComponent(
                    category: .savings,
                    score: 80.0,
                    details: "Good savings habits with regular deposits"
                ),
                ScoreComponent(
                    category: .spending,
                    score: 70.0,
                    details: "Moderate control over discretionary spending"
                )
            ]
        )
        score.overallScore = 75.0
        score.savingsRatio = 0.2
        score.trend = 5.5
        score.recommendations = [
            FinGripRecommendation(
                title: "Increase Emergency Fund",
                description: "Build up your emergency fund to cover 6 months of expenses",
                type: .saving,
                priority: .high,
                impact: .significant
            )
        ]
        return score
    }
}