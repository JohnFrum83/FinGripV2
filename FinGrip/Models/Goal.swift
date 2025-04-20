import Foundation
import SwiftUI

/// A financial goal that users can create and track in the FinGrip app.
/// This struct represents both preset and custom goals, storing information about
/// the target amount, current progress, and deadline.
///
/// Usage example:
/// ```swift
/// let emergencyFund = Goal(
///     title: "Emergency Fund",
///     targetAmount: 10000,
///     deadline: Date().addingTimeInterval(365*24*60*60),
///     category: .savings,
///     icon: "banknote"
/// )
/// ```
struct Goal: Identifiable, Codable, Hashable {
    /// Unique identifier for the goal
    let id: UUID
    
    /// The name or description of the goal
    var title: String
    
    /// The total amount the user wants to save/invest
    var targetAmount: Double
    
    /// The current amount saved/invested towards this goal
    var currentAmount: Double
    
    /// The target date by which the user wants to achieve this goal
    var deadline: Date
    
    /// Category of the goal
    var category: FinancialCategory
    
    /// SF Symbol name for the goal's icon
    var icon: String
    
    /// Creates a new goal with the specified parameters
    /// - Parameters:
    ///   - id: Optional UUID, will be auto-generated if not provided
    ///   - title: The name of the goal
    ///   - targetAmount: The amount to be saved/invested
    ///   - currentAmount: The amount already saved (defaults to 0)
    ///   - deadline: The target completion date
    ///   - category: Category of the goal
    ///   - icon: SF Symbol name for the goal's icon
    init(id: UUID = UUID(), title: String, targetAmount: Double, currentAmount: Double = 0, deadline: Date, category: FinancialCategory, icon: String) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.category = category
        self.icon = icon
    }
    
    /// Calculates the progress towards the goal as a percentage (0.0 to 1.0)
    var progress: Double {
        currentAmount / targetAmount
    }
    
    /// Implements Hashable conformance using the goal's unique identifier
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Implements equality comparison using the goal's unique identifier
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
} 