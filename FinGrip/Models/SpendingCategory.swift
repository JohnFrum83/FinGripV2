import Foundation
import SwiftUI

/// A model representing a spending category with its properties and spending limits
struct SpendingCategory: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: String
    var color: String
    var monthlyLimit: Double
    var currentSpending: Double
    var transactions: [Transaction]
    var budget: Double
    var totalSpent: Double
    
    /// Default categories for initial setup
    static let defaultCategories: [SpendingCategory] = [
        SpendingCategory(name: "Food & Dining", icon: "fork.knife", color: "green", monthlyLimit: 500, budget: 500),
        SpendingCategory(name: "Transportation", icon: "car.fill", color: "blue", monthlyLimit: 300, budget: 300),
        SpendingCategory(name: "Shopping", icon: "cart.fill", color: "purple", monthlyLimit: 400, budget: 400),
        SpendingCategory(name: "Entertainment", icon: "film.fill", color: "orange", monthlyLimit: 200, budget: 200),
        SpendingCategory(name: "Healthcare", icon: "heart.fill", color: "red", monthlyLimit: 300, budget: 300),
        SpendingCategory(name: "Utilities", icon: "bolt.fill", color: "yellow", monthlyLimit: 250, budget: 250)
    ]
    
    /// Percentage of monthly limit used
    var usagePercentage: Double {
        guard monthlyLimit > 0 else { return 0 }
        return min((currentSpending / monthlyLimit) * 100, 100)
    }
    
    /// Remaining budget for the month
    var remainingBudget: Double {
        monthlyLimit - currentSpending
    }
    
    /// Initialize a new spending category
    init(id: UUID = UUID(), 
         name: String, 
         icon: String, 
         color: String = "blue",
         monthlyLimit: Double = 0, 
         currentSpending: Double = 0,
         transactions: [Transaction] = [],
         budget: Double = 0,
         totalSpent: Double = 0) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.monthlyLimit = monthlyLimit
        self.currentSpending = currentSpending
        self.transactions = transactions
        self.budget = budget
        self.totalSpent = totalSpent
    }
    
    /// Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Equatable conformance
    static func == (lhs: SpendingCategory, rhs: SpendingCategory) -> Bool {
        lhs.id == rhs.id
    }
} 