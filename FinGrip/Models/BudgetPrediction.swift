import Foundation
import SwiftUI

struct BudgetPrediction: Identifiable {
    let id: UUID
    let month: Date
    let predictedIncome: Double
    let predictedExpenses: Double
    let confidenceLevel: ConfidenceLevel
    let categories: [CategoryPrediction]
    
    var predictedSavings: Double {
        predictedIncome - predictedExpenses
    }
    
    init(
        id: UUID = UUID(),
        month: Date,
        predictedIncome: Double,
        predictedExpenses: Double,
        confidenceLevel: ConfidenceLevel,
        categories: [CategoryPrediction]
    ) {
        self.id = id
        self.month = month
        self.predictedIncome = predictedIncome
        self.predictedExpenses = predictedExpenses
        self.confidenceLevel = confidenceLevel
        self.categories = categories
    }
    
    enum ConfidenceLevel: String {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: Color {
            switch self {
            case .high: return .green
            case .medium: return .yellow
            case .low: return .red
            }
        }
    }
    
    struct CategoryPrediction: Identifiable {
        let id: UUID
        let category: FinancialCategory
        let amount: Double
        let trend: Trend
        
        init(
            id: UUID = UUID(),
            category: FinancialCategory,
            amount: Double,
            trend: Trend
        ) {
            self.id = id
            self.category = category
            self.amount = amount
            self.trend = trend
        }
        
        enum Trend: String {
            case increasing = "Increasing"
            case decreasing = "Decreasing"
            case stable = "Stable"
            
            var icon: String {
                switch self {
                case .increasing: return "arrow.up.right"
                case .decreasing: return "arrow.down.right"
                case .stable: return "arrow.right"
                }
            }
            
            var color: Color {
                switch self {
                case .increasing: return .red
                case .decreasing: return .green
                case .stable: return .blue
                }
            }
        }
    }
    
    /// Returns a formatted string representation of the month
    var monthDisplay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
    
    /// Returns the total predicted amount for a specific category
    func predictedAmount(for category: FinancialCategory) -> Double {
        categories.first { $0.category == category }?.amount ?? 0
    }
    
    /// Returns categories sorted by predicted amount
    var categoriesByAmount: [CategoryPrediction] {
        categories.sorted { $0.amount > $1.amount }
    }
    
    /// Returns the category with the highest predicted amount
    var highestCategory: CategoryPrediction? {
        categories.max { $0.amount < $1.amount }
    }
    
    /// Returns categories with an increasing trend
    var increasingCategories: [CategoryPrediction] {
        categories.filter { $0.trend == .increasing }
    }
} 