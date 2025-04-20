import Foundation
import SwiftUI

/// Represents different categories of financial activities
enum FinancialCategory: String, Codable, CaseIterable, Hashable {
    /// Savings-related activities
    case savings
    
    /// Debt-related activities
    case debt
    
    /// Spending-related activities
    case spending
    
    /// Income-related activities
    case income
    
    /// The system name of the icon to use for this category
    var icon: String {
        switch self {
        case .savings: return "banknote"
        case .debt: return "creditcard"
        case .spending: return "cart"
        case .income: return "dollarsign.circle"
        }
    }
    
    /// The color to use for this category
    var color: Color {
        switch self {
        case .savings: return .blue
        case .debt: return .red
        case .spending: return .orange
        case .income: return .green
        }
    }
    
    /// The display name of the category
    var displayName: String {
        switch self {
        case .savings: return "Savings"
        case .debt: return "Debt"
        case .spending: return "Spending"
        case .income: return "Income"
        }
    }
} 