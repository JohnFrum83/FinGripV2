import Foundation
import SwiftUI

/// Represents a financial transaction in the FinGrip app
struct Transaction: Identifiable, Codable {
    /// Unique identifier for the transaction
    let id: UUID
    
    /// Title or description of the transaction
    let title: String
    
    /// Amount of the transaction
    let amount: Double
    
    /// Category of the transaction
    let category: FinancialCategory
    
    /// Date when the transaction occurred
    let date: Date
    
    /// Type of the transaction (income or expense)
    let type: TransactionType
    
    /// Creates a new transaction
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - title: Title or description
    ///   - amount: Transaction amount
    ///   - category: Transaction category
    ///   - date: Transaction date
    ///   - type: Transaction type
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        category: FinancialCategory,
        date: Date = Date(),
        type: TransactionType
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.type = type
    }
    
    /// Formatted date string for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    /// Formatted amount string for display
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD" // TODO: Use user's selected currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case amount
        case category
        case date
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Double.self, forKey: .amount)
        category = try container.decode(FinancialCategory.self, forKey: .category)
        date = try container.decode(Date.self, forKey: .date)
        type = try container.decode(TransactionType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(amount, forKey: .amount)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
    }
    
    static var sample: Transaction {
        Transaction(
            title: "Grocery Shopping",
            amount: 45.67,
            category: .spending,
            date: Date(),
            type: .expense
        )
    }
}

/// Represents the type of a transaction
enum TransactionType: String, Codable, CaseIterable {
    /// Income transaction
    case income
    
    /// Expense transaction
    case expense
} 