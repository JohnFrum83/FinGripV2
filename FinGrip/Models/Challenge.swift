import Foundation

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
        case easy
        /// Moderate challenges requiring some effort
        case medium
        /// Challenging tasks requiring significant commitment
        case hard
    }
    
    /// Unique identifier for the challenge
    let id: UUID
    
    /// Name of the challenge
    var title: String
    
    /// Detailed explanation of what the user needs to do
    var description: String
    
    /// Number of points awarded for completing the challenge
    let points: Int
    
    /// How difficult the challenge is to complete
    let difficulty: Difficulty
    
    /// Whether the challenge has been completed
    var isCompleted: Bool
    
    /// When the challenge was started
    let createdAt: Date
    
    /// Optional deadline for completing the challenge
    var endDate: Date
    
    /// Creates a new challenge with the specified parameters
    /// - Parameters:
    ///   - id: Optional UUID, will be auto-generated if not provided
    ///   - title: Name of the challenge
    ///   - description: Detailed explanation of the challenge
    ///   - points: Reward points for completion
    ///   - difficulty: How hard the challenge is
    ///   - isCompleted: Whether it's been completed (defaults to false)
    ///   - createdAt: When the challenge begins (defaults to current date/time)
    ///   - endDate: Optional deadline for completion
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        points: Int,
        difficulty: Difficulty,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        endDate: Date
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.points = points
        self.difficulty = difficulty
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.endDate = endDate
    }
    
    /// Marks the challenge as completed
    mutating func complete() {
        self.isCompleted = true
    }
    
    /// Checks if the challenge is still active based on its end date
    var isActive: Bool {
        Date() <= endDate
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
                id: UUID(),
                title: "Save $100 this week",
                description: "Put aside $100 for your emergency fund",
                points: 50,
                difficulty: .easy,
                endDate: Date().addingTimeInterval(7*24*60*60)
            ),
            Challenge(
                id: UUID(),
                title: "Review your budget",
                description: "Take 15 minutes to review and adjust your monthly budget",
                points: 30,
                difficulty: .medium,
                endDate: Date().addingTimeInterval(14*24*60*60)
            )
        ]
    }
} 