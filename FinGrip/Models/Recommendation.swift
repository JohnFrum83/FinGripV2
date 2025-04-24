import Foundation
import SwiftUI

/// A model representing a financial recommendation
struct FinGripRecommendation: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    var type: RecommendationType
    var priority: Priority
    var impact: Impact
    var isImplemented: Bool
    var dateCreated: Date
    
    /// Types of financial recommendations
    enum RecommendationType: String, CaseIterable, Codable, Hashable {
        case spending = "Spending"
        case saving = "Saving"
        case investment = "Investment"
        case debt = "Debt"
        case budgeting = "Budgeting"
        case income = "Income"
        
        var icon: String {
            switch self {
            case .spending: return "cart.fill"
            case .saving: return "banknote.fill"
            case .investment: return "chart.line.uptrend.xyaxis"
            case .debt: return "creditcard.fill"
            case .budgeting: return "chart.pie.fill"
            case .income: return "dollarsign.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .spending: return .red
            case .saving: return .green
            case .investment: return .blue
            case .debt: return .orange
            case .budgeting: return .purple
            case .income: return .mint
            }
        }
    }
    
    /// Priority levels for recommendations
    enum Priority: String, CaseIterable, Codable, Hashable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var color: Color {
            switch self {
            case .high: return .red
            case .medium: return .yellow
            case .low: return .green
            }
        }
    }
    
    /// Impact levels for recommendations
    enum Impact: String, CaseIterable, Codable, Hashable {
        case significant = "Significant"
        case moderate = "Moderate"
        case minimal = "Minimal"
        
        var description: String {
            switch self {
            case .significant: return "Major improvement in financial health"
            case .moderate: return "Noticeable improvement in specific areas"
            case .minimal: return "Small but positive change"
            }
        }
    }
    
    /// Initialize a new recommendation
    init(id: UUID = UUID(),
         title: String,
         description: String,
         type: RecommendationType,
         priority: Priority,
         impact: Impact,
         isImplemented: Bool = false,
         dateCreated: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.priority = priority
        self.impact = impact
        self.isImplemented = isImplemented
        self.dateCreated = dateCreated
    }
    
    /// Sample recommendations for preview and testing
    static let sampleRecommendations: [FinGripRecommendation] = [
        FinGripRecommendation(
            title: "Reduce Dining Out Expenses",
            description: "Consider cooking more meals at home to reduce food expenses by 20%",
            type: .spending,
            priority: .high,
            impact: .significant
        ),
        FinGripRecommendation(
            title: "Start Emergency Fund",
            description: "Build an emergency fund covering 3-6 months of expenses",
            type: .saving,
            priority: .high,
            impact: .significant
        ),
        FinGripRecommendation(
            title: "Review Subscriptions",
            description: "Audit and cancel unused subscription services",
            type: .budgeting,
            priority: .medium,
            impact: .moderate
        )
    ]
    
    /// Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Equatable conformance
    static func == (lhs: FinGripRecommendation, rhs: FinGripRecommendation) -> Bool {
        lhs.id == rhs.id
    }
}

// Type alias for backward compatibility
typealias Recommendation = FinGripRecommendation 