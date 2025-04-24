import Foundation
import SwiftUI

/// Tracks savings opportunities and progress
struct SavingsTracker: Identifiable, Codable {
    let id: UUID
    var opportunities: [SavingOpportunity]
    var totalSaved: Double
    var monthlyProgress: [MonthlyProgress]
    var monthlyTarget: Double
    var yearlyTarget: Double
    var implementedSavings: [ImplementedSaving]
    
    var totalPotentialSavings: Double {
        opportunities.reduce(0) { $0 + $1.potentialSavingsAmount }
    }
    
    var totalImplementedSavings: Double {
        implementedSavings.reduce(0) { $0 + $1.amount }
    }
    
    init(
        id: UUID = UUID(),
        opportunities: [SavingOpportunity] = [],
        totalSaved: Double = 0,
        monthlyProgress: [MonthlyProgress] = [],
        monthlyTarget: Double = 500,
        yearlyTarget: Double = 6000,
        implementedSavings: [ImplementedSaving] = []
    ) {
        self.id = id
        self.opportunities = opportunities
        self.totalSaved = totalSaved
        self.monthlyProgress = monthlyProgress
        self.monthlyTarget = monthlyTarget
        self.yearlyTarget = yearlyTarget
        self.implementedSavings = implementedSavings
    }
    
    mutating func addOpportunity(_ opportunity: SavingOpportunity) {
        opportunities.append(opportunity)
    }
    
    mutating func removeOpportunity(at index: Int) {
        opportunities.remove(at: index)
    }
    
    mutating func implementOpportunity(at index: Int) {
        opportunities[index].implement()
    }
    
    var savingsProgress: Double {
        guard totalPotentialSavings > 0 else { return 0 }
        return (totalImplementedSavings / totalPotentialSavings) * 100
    }
    
    /// Returns the progress towards the monthly target as a percentage
    var monthlyProgressPercentage: Double {
        let monthlySavingsAmount = monthlySavings()
        return monthlyTarget > 0 ? (monthlySavingsAmount / monthlyTarget) * 100 : 0
    }
    
    /// Returns the progress towards the yearly target as a percentage
    var yearlyProgressPercentage: Double {
        yearlyTarget > 0 ? (totalSaved / yearlyTarget) * 100 : 0
    }
    
    /// Categories of saving opportunities
    enum SavingCategory: String, CaseIterable {
        case subscriptions = "Subscriptions"
        case utilities = "Utilities"
        case shopping = "Shopping"
        case entertainment = "Entertainment"
        case transportation = "Transportation"
        case food = "Food & Dining"
        case other = "Other"
    }
    
    /// Difficulty levels for implementing savings
    enum SavingDifficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case moderate = "Moderate"
        case challenging = "Challenging"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .moderate: return .orange
            case .challenging: return .red
            }
        }
    }
    
    /// Returns opportunities filtered by category
    func opportunities(in category: FinancialCategory) -> [SavingOpportunity] {
        opportunities.filter { $0.category == category }
    }
    
    /// Returns opportunities filtered by difficulty
    func opportunities(with difficulty: SavingOpportunity.Difficulty) -> [SavingOpportunity] {
        opportunities.filter { $0.difficulty == difficulty }
    }
    
    /// Returns opportunities sorted by potential impact (savings amount)
    var prioritizedOpportunities: [SavingOpportunity] {
        opportunities.sorted { $0.potentialSavingsAmount > $1.potentialSavingsAmount }
    }
    
    /// Returns opportunities that haven't been implemented yet
    var pendingOpportunities: [SavingOpportunity] {
        opportunities.filter { !$0.isImplemented }
    }
    
    mutating func addSaving(amount: Double, category: FinancialCategory) {
        totalSaved += amount
        
        let calendar = Calendar.current
        let currentMonth = calendar.startOfMonth(for: Date())
        
        if let index = monthlyProgress.firstIndex(where: { calendar.startOfMonth(for: $0.month) == currentMonth }) {
            monthlyProgress[index].amount += amount
            monthlyProgress[index].categories[category, default: 0] += amount
        } else {
            monthlyProgress.append(MonthlyProgress(
                month: currentMonth,
                amount: amount,
                categories: [category: amount]
            ))
        }
    }
    
    func monthlySavings(for date: Date = Date()) -> Double {
        let calendar = Calendar.current
        let month = calendar.startOfMonth(for: date)
        return monthlyProgress
            .first(where: { calendar.startOfMonth(for: $0.month) == month })?
            .amount ?? 0
    }
    
    func savingsByCategory(for date: Date = Date()) -> [FinancialCategory: Double] {
        let calendar = Calendar.current
        let month = calendar.startOfMonth(for: date)
        return monthlyProgress
            .first(where: { calendar.startOfMonth(for: $0.month) == month })?
            .categories ?? [:]
    }
}

/// Represents an implemented saving
struct ImplementedSaving: Identifiable, Codable {
    let id: UUID
    let opportunity: SavingOpportunity
    let date: Date
    let amount: Double
    let notes: String?
    
    init(
        id: UUID = UUID(),
        opportunity: SavingOpportunity,
        date: Date = Date(),
        amount: Double,
        notes: String? = nil
    ) {
        self.id = id
        self.opportunity = opportunity
        self.date = date
        self.amount = amount
        self.notes = notes
    }
}

struct MonthlyProgress: Codable, Identifiable {
    let id: UUID
    let month: Date
    var amount: Double
    var categories: [FinancialCategory: Double]
    
    init(id: UUID = UUID(), month: Date = Date(), amount: Double = 0, categories: [FinancialCategory: Double] = [:]) {
        self.id = id
        self.month = month
        self.amount = amount
        self.categories = categories
    }
}

// MARK: - Calendar Extension
private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

// MARK: - Sample Data
extension SavingsTracker {
    static var sampleTracker: SavingsTracker {
        SavingsTracker(opportunities: SavingOpportunity.sampleOpportunities)
    }
} 