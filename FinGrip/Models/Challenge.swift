import Foundation
import SwiftUI

/// Represents a financial challenge or task that users can complete
/// to improve their financial habits and earn rewards.
///
/// Challenges are designed to encourage positive financial behavior
/// through gamification elements like points and progress tracking.
///
/// Usage example:
/// ```swift
/// let savingChallenge = Challenge(
///     title: "No Spend Week",
///     description: "Avoid non-essential purchases for 7 days",
///     points: 100,
///     difficulty: .medium
/// )
/// ```
struct Challenge: Identifiable, Codable, Hashable {
    /// Represents the difficulty level of a challenge
    enum Difficulty: String, Codable, CaseIterable {
        /// Easy challenges for beginners
        case easy = "Easy"
        /// Moderate challenges requiring some effort
        case medium = "Medium"
        /// Challenging tasks requiring significant commitment
        case hard = "Hard"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .easy: return "1.circle.fill"
            case .medium: return "2.circle.fill"
            case .hard: return "3.circle.fill"
            }
        }
    }
    
    /// Unique identifier for the challenge
    let id: UUID
    
    /// Name of the challenge
    var title: String
    
    /// Detailed explanation of what the user needs to do
    var description: String
    
    /// Category of the challenge
    let category: FinancialCategory
    
    /// Reward amount for completing the challenge
    let reward: Double
    
    /// Duration of the challenge in days
    let duration: Int
    
    /// How difficult the challenge is to complete
    let difficulty: Difficulty
    
    /// Points for completing the challenge
    let points: Int
    
    /// Whether the challenge has been completed
    var isCompleted: Bool
    
    /// When the challenge was started
    let startDate: Date
    
    /// Optional deadline for completing the challenge
    var endDate: Date?
    
    /// Steps to complete the challenge
    let steps: [String]
    
    /// Creates a new challenge with the specified parameters
    /// - Parameters:
    ///   - id: Optional UUID, will be auto-generated if not provided
    ///   - title: Name of the challenge
    ///   - description: Detailed explanation of the challenge
    ///   - category: Category of the challenge
    ///   - reward: Reward amount for completion
    ///   - duration: Duration of the challenge in days
    ///   - difficulty: How hard the challenge is
    ///   - points: Points for completing the challenge
    ///   - isCompleted: Whether it's been completed (defaults to false)
    ///   - startDate: When the challenge begins (defaults to current date/time)
    ///   - endDate: Optional deadline for completion
    ///   - steps: Steps to complete the challenge
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: FinancialCategory,
        reward: Double,
        duration: Int,
        difficulty: Difficulty,
        points: Int,
        isCompleted: Bool = false,
        startDate: Date = Date(),
        endDate: Date? = nil,
        steps: [String] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.reward = reward
        self.duration = duration
        self.difficulty = difficulty
        self.points = points
        self.isCompleted = isCompleted
        self.startDate = startDate
        self.endDate = endDate
        self.steps = steps
    }
    
    /// Marks the challenge as completed
    mutating func complete() {
        self.isCompleted = true
    }
    
    /// Checks if the challenge is still active based on its end date
    var isActive: Bool {
        guard let endDate = endDate else { return false }
        return Date() <= endDate
    }
    
    /// Formats the reward amount as a string
    var formattedReward: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = LocalizationManager.shared.selectedCurrency.rawValue
        return formatter.string(from: NSNumber(value: reward)) ?? "\(reward)"
    }
    
    /// Formats the duration of the challenge as a string
    var formattedDuration: String {
        if duration == 1 {
            return "1 day"
        } else if duration < 7 {
            return "\(duration) days"
        } else if duration == 7 {
            return "1 week"
        } else if duration % 7 == 0 {
            return "\(duration / 7) weeks"
        } else {
            return "\(duration) days"
        }
    }
    
    /// Calculates the progress of the challenge
    var progress: Double {
        guard let endDate = endDate else { return 0 }
        let total = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / total, 0), 1)
    }
    
    /// Checks if the challenge is expired
    var isExpired: Bool {
        guard let endDate = endDate else { return false }
        return Date() > endDate
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Preview Helpers
extension Challenge {
    static var sampleData: [Challenge] {
        [
            Challenge(
                title: "Save $500",
                description: "Build an emergency fund by saving $500",
                category: .savings,
                reward: 50.0,
                duration: 30,
                difficulty: .medium,
                points: 100,
                steps: ["Open a savings account", "Set up automatic transfers", "Track your progress"]
            ),
            Challenge(
                title: "No Dining Out Week",
                description: "Avoid eating out for one week",
                category: .spending,
                reward: 30.0,
                duration: 7,
                difficulty: .easy,
                points: 50,
                steps: ["Plan your meals", "Grocery shopping", "Cook at home"]
            ),
            Challenge(
                title: "Investment Research",
                description: "Learn about investment options",
                category: .investments,
                reward: 100.0,
                duration: 14,
                difficulty: .hard,
                points: 150,
                steps: ["Read investment guides", "Compare different options", "Create investment plan"]
            )
        ]
    }
    
    static var sample: Challenge {
        Challenge(
            title: "Save $100 this week",
            description: "Cut back on non-essential spending and save $100",
            category: .savings,
            reward: 50.0,
            duration: 7,
            difficulty: .medium,
            points: 100,
            steps: [
                "Review your current spending habits",
                "Identify non-essential expenses",
                "Set up automatic savings transfer",
                "Track your progress daily"
            ]
        )
    }
} 