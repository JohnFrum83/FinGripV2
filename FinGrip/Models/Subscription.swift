import Foundation
import SwiftUI

/// Represents a subscription service that a user pays for regularly
struct Subscription: Identifiable, Codable, Equatable {
    /// Unique identifier for the subscription
    let id: UUID
    
    /// Name of the subscription service
    var name: String
    
    /// Category of the subscription
    var category: SubscriptionCategory
    
    /// Monthly amount charged for the subscription
    var monthlyAmount: Double
    
    /// How often the subscription is billed
    var billingCycle: BillingCycle
    
    /// Is the subscription active
    var isActive: Bool
    
    /// Last time the subscription was billed
    var lastBillingDate: Date?
    
    /// Next time the subscription is billed
    var nextBillingDate: Date?
    
    /// Notes about the subscription
    var notes: String?
    
    /// Last time the subscription was used
    var lastUsed: Date?
    
    /// Creates a new subscription
    /// - Parameters:
    ///   - id: Optional UUID, will be auto-generated if not provided
    ///   - name: Name of the subscription service
    ///   - category: Type of subscription
    ///   - monthlyAmount: Monthly amount charged
    ///   - billingCycle: Billing frequency
    ///   - isActive: Is the subscription active
    ///   - lastBillingDate: Last time the subscription was billed
    ///   - nextBillingDate: Next time the subscription is billed
    ///   - notes: Notes about the subscription (optional)
    ///   - lastUsed: When the subscription was last used (optional)
    init(
        id: UUID = UUID(),
        name: String,
        category: SubscriptionCategory,
        monthlyAmount: Double,
        billingCycle: BillingCycle = .monthly,
        isActive: Bool = true,
        lastBillingDate: Date? = nil,
        nextBillingDate: Date? = nil,
        notes: String? = nil,
        lastUsed: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.monthlyAmount = monthlyAmount
        self.billingCycle = billingCycle
        self.isActive = isActive
        self.lastBillingDate = lastBillingDate
        self.nextBillingDate = nextBillingDate
        self.notes = notes
        self.lastUsed = lastUsed
    }
    
    /// How often the subscription is billed
    enum BillingCycle: String, Codable, CaseIterable {
        case monthly
        case quarterly
        case yearly
        
        var multiplier: Int {
            switch self {
            case .monthly: return 1
            case .quarterly: return 3
            case .yearly: return 12
            }
        }
    }
    
    /// Types of subscription services
    enum SubscriptionCategory: String, Codable, CaseIterable {
        case streaming
        case entertainment
        case utilities
        case software
        case fitness
        case other
        
        var icon: String {
            switch self {
            case .streaming: return "play.tv"
            case .entertainment: return "film"
            case .utilities: return "bolt"
            case .software: return "laptopcomputer"
            case .fitness: return "figure.walk"
            case .other: return "square.stack"
            }
        }
        
        var color: Color {
            switch self {
            case .streaming: return .red
            case .utilities: return .yellow
            case .software: return .blue
            case .fitness: return .orange
            case .other: return .gray
            default: return .black
            }
        }
    }
    
    /// Calculates the monthly cost of the subscription
    var actualMonthlyAmount: Double {
        monthlyAmount * Double(billingCycle.multiplier)
    }
    
    /// Checks if the subscription hasn't been used in over 30 days
    var isUnused: Bool {
        guard let lastUsed = lastUsed else { return true }
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return lastUsed < thirtyDaysAgo
    }
    
    var formattedPrice: String {
        return monthlyAmount.currencyFormatted()
    }
    
    var annualCost: Double {
        return monthlyAmount * 12
    }
    
    static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Sample Data
extension Subscription {
    static var sampleSubscriptions: [Subscription] = [
        Subscription(
            name: "Netflix",
            category: .streaming,
            monthlyAmount: 15.99,
            billingCycle: .monthly
        ),
        Subscription(
            name: "Spotify",
            category: .streaming,
            monthlyAmount: 9.99,
            billingCycle: .monthly
        ),
        Subscription(
            name: "Adobe Creative Cloud",
            category: .software,
            monthlyAmount: 52.99,
            billingCycle: .monthly
        )
    ]
}