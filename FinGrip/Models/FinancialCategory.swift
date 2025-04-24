import Foundation
import SwiftUI

/// Represents different categories of financial activities
enum FinancialCategory: String, CaseIterable, Identifiable, Codable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food & Dining"
    case utilities = "Utilities"
    case insurance = "Insurance"
    case healthcare = "Healthcare"
    case savings = "Savings"
    case debt = "Debt"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case education = "Education"
    case investments = "Investments"
    case subscriptions = "Subscriptions"
    case income = "Income"
    case spending = "Spending"
    case other = "Other"
    
    var id: String { rawValue }
    
    /// The system name of the icon to use for this category
    var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .transportation: return "car.fill"
        case .food: return "fork.knife"
        case .utilities: return "bolt.fill"
        case .insurance: return "shield.fill"
        case .healthcare: return "heart.fill"
        case .savings: return "banknote.fill"
        case .debt: return "creditcard.fill"
        case .entertainment: return "film.fill"
        case .shopping: return "cart.fill"
        case .education: return "book.fill"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .subscriptions: return "repeat"
        case .income: return "dollarsign.circle.fill"
        case .spending: return "arrow.left.arrow.right"
        case .other: return "ellipsis"
        }
    }
    
    /// The color to use for this category
    var color: Color {
        switch self {
        case .housing: return .blue
        case .transportation: return .green
        case .food: return .orange
        case .utilities: return .yellow
        case .insurance: return .purple
        case .healthcare: return .red
        case .savings: return .mint
        case .debt: return .pink
        case .entertainment: return .indigo
        case .shopping: return .brown
        case .education: return .cyan
        case .investments: return .teal
        case .subscriptions: return .gray
        case .income: return .green
        case .spending: return .red
        case .other: return .secondary
        }
    }
    
    /// The display name of the category
    var displayName: String {
        switch self {
        case .housing: return "Housing"
        case .transportation: return "Transportation"
        case .food: return "Food & Dining"
        case .utilities: return "Utilities"
        case .insurance: return "Insurance"
        case .healthcare: return "Healthcare"
        case .savings: return "Savings"
        case .debt: return "Debt"
        case .entertainment: return "Entertainment"
        case .shopping: return "Shopping"
        case .education: return "Education"
        case .investments: return "Investments"
        case .subscriptions: return "Subscriptions"
        case .income: return "Income"
        case .spending: return "Spending"
        case .other: return "Other"
        }
    }
    
    /// Returns a suggested monthly budget percentage for this category
    var suggestedBudgetPercentage: Double {
        switch self {
        case .housing: return 0.30 // 30% of income
        case .transportation: return 0.15
        case .food: return 0.12
        case .utilities: return 0.08
        case .insurance: return 0.10
        case .healthcare: return 0.06
        case .savings: return 0.10
        case .debt: return 0.05
        case .entertainment: return 0.04
        case .shopping: return 0.05
        case .education: return 0.02
        case .investments: return 0.05
        case .subscriptions: return 0.03
        case .income: return 0.00
        case .spending: return 0.00
        case .other: return 0.02
        }
    }
    
    /// Returns a localized description of the category
    var description: String {
        switch self {
        case .housing: return NSLocalizedString("category.housing.description", comment: "Housing expenses including rent/mortgage, maintenance")
        case .transportation: return NSLocalizedString("category.transportation.description", comment: "Transportation costs including car payments, fuel, public transit")
        case .food: return NSLocalizedString("category.food.description", comment: "Food and dining expenses including groceries and restaurants")
        case .utilities: return NSLocalizedString("category.utilities.description", comment: "Utility bills including electricity, water, gas")
        case .insurance: return NSLocalizedString("category.insurance.description", comment: "Insurance premiums for health, car, home")
        case .healthcare: return NSLocalizedString("category.healthcare.description", comment: "Healthcare expenses including medications and doctor visits")
        case .savings: return NSLocalizedString("category.savings.description", comment: "Money set aside for savings and emergency fund")
        case .debt: return NSLocalizedString("category.debt.description", comment: "Debt payments including credit cards and loans")
        case .entertainment: return NSLocalizedString("category.entertainment.description", comment: "Entertainment expenses including movies, games, hobbies")
        case .shopping: return NSLocalizedString("category.shopping.description", comment: "Shopping expenses for clothing, electronics, etc.")
        case .education: return NSLocalizedString("category.education.description", comment: "Education expenses including tuition and books")
        case .investments: return NSLocalizedString("category.investments.description", comment: "Investment contributions including stocks and retirement")
        case .subscriptions: return NSLocalizedString("category.subscriptions.description", comment: "Recurring subscription payments")
        case .income: return NSLocalizedString("category.income.description", comment: "Income from various sources")
        case .spending: return NSLocalizedString("category.spending.description", comment: "Spending on various expenses")
        case .other: return NSLocalizedString("category.other.description", comment: "Other miscellaneous expenses")
        }
    }
} 