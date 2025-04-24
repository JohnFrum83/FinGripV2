import Foundation
import SwiftUI

/// Represents a financial transaction in the FinGrip app
struct Transaction: Identifiable, Codable {
    /// Unique identifier for the transaction
    let id: UUID
    
    /// Date when the transaction occurred
    let date: Date
    
    /// Amount of the transaction
    let amount: Double
    
    /// Type of the transaction (income, expense, or transfer)
    let type: TransactionType
    
    /// Category of the transaction
    let category: FinancialCategory
    
    /// Description of the transaction
    let description: String
    
    /// Merchant associated with the transaction
    let merchant: String?
    
    /// Location associated with the transaction
    let location: String?
    
    /// Whether the transaction is recurring
    let isRecurring: Bool
    
    /// Tags associated with the transaction
    let tags: [String]
    
    /// Creates a new transaction
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - date: Transaction date
    ///   - amount: Transaction amount
    ///   - type: Transaction type
    ///   - category: Transaction category
    ///   - description: Transaction description
    ///   - merchant: Merchant associated with the transaction
    ///   - location: Location associated with the transaction
    ///   - isRecurring: Whether the transaction is recurring
    ///   - tags: Tags associated with the transaction
    init(
        id: UUID = UUID(),
        date: Date,
        amount: Double,
        type: TransactionType,
        category: FinancialCategory,
        description: String,
        merchant: String? = nil,
        location: String? = nil,
        isRecurring: Bool = false,
        tags: [String] = []
    ) {
        self.id = id
        self.date = date
        self.amount = amount
        self.type = type
        self.category = category
        self.description = description
        self.merchant = merchant
        self.location = location
        self.isRecurring = isRecurring
        self.tags = tags
    }
    
    /// Formatted date string for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    /// Formatted amount string for display
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = LocalizationManager.shared.selectedCurrency.rawValue
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    /// Formatted month and year string for display
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case amount
        case type
        case category
        case description
        case merchant
        case location
        case isRecurring
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        amount = try container.decode(Double.self, forKey: .amount)
        type = try container.decode(TransactionType.self, forKey: .type)
        category = try container.decode(FinancialCategory.self, forKey: .category)
        description = try container.decode(String.self, forKey: .description)
        merchant = try container.decode(String?.self, forKey: .merchant)
        location = try container.decode(String?.self, forKey: .location)
        isRecurring = try container.decode(Bool.self, forKey: .isRecurring)
        tags = try container.decode([String].self, forKey: .tags)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(amount, forKey: .amount)
        try container.encode(type, forKey: .type)
        try container.encode(category, forKey: .category)
        try container.encode(description, forKey: .description)
        try container.encode(merchant, forKey: .merchant)
        try container.encode(location, forKey: .location)
        try container.encode(isRecurring, forKey: .isRecurring)
        try container.encode(tags, forKey: .tags)
    }
    
    static var sample: Transaction {
        Transaction(
            date: Date(),
            amount: 45.67,
            type: .expense,
            category: .spending,
            description: "Grocery Shopping",
            merchant: "Whole Foods",
            location: "123 Main St, Anytown, USA"
        )
    }
}

/// Represents the type of a transaction
enum TransactionType: String, Codable, CaseIterable {
    /// Income transaction
    case income = "Income"
    
    /// Expense transaction
    case expense = "Expense"
    
    /// Transfer transaction
    case transfer = "Transfer"
    
    var color: Color {
        switch self {
        case .income: return .green
        case .expense: return .red
        case .transfer: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .income: return "arrow.down.circle.fill"
        case .expense: return "arrow.up.circle.fill"
        case .transfer: return "arrow.right.circle.fill"
        }
    }
} 