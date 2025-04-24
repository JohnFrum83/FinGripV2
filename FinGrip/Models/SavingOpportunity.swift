import Foundation

struct SavingOpportunity: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var potentialSavingsAmount: Double
    var category: FinancialCategory
    var timeframe: Timeframe
    var difficulty: Difficulty
    var isImplemented: Bool
    var dateCreated: Date
    var dateImplemented: Date?
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case moderate = "Moderate"
        case challenging = "Challenging"
        
        var description: String {
            switch self {
            case .easy:
                return NSLocalizedString("Simple changes with immediate impact", comment: "Easy difficulty description")
            case .moderate:
                return NSLocalizedString("Requires some effort and planning", comment: "Moderate difficulty description")
            case .challenging:
                return NSLocalizedString("Significant lifestyle changes needed", comment: "Challenging difficulty description")
            }
        }
    }
    
    enum Timeframe: String, Codable, CaseIterable {
        case immediate = "Immediate"
        case shortTerm = "Short Term"
        case mediumTerm = "Medium Term"
        case longTerm = "Long Term"
        
        var description: String {
            switch self {
            case .immediate:
                return NSLocalizedString("Can be implemented right away", comment: "Immediate timeframe description")
            case .shortTerm:
                return NSLocalizedString("Can be implemented within a month", comment: "Short term timeframe description")
            case .mediumTerm:
                return NSLocalizedString("Can be implemented within 3-6 months", comment: "Medium term timeframe description")
            case .longTerm:
                return NSLocalizedString("Takes more than 6 months to implement", comment: "Long term timeframe description")
            }
        }
    }
    
    init(id: UUID = UUID(),
         title: String,
         description: String,
         potentialSavingsAmount: Double,
         category: FinancialCategory,
         timeframe: Timeframe,
         difficulty: Difficulty = .moderate,
         isImplemented: Bool = false,
         dateCreated: Date = Date(),
         dateImplemented: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.potentialSavingsAmount = potentialSavingsAmount
        self.category = category
        self.timeframe = timeframe
        self.difficulty = difficulty
        self.isImplemented = isImplemented
        self.dateCreated = dateCreated
        self.dateImplemented = dateImplemented
    }
    
    mutating func implement() {
        isImplemented = true
        dateImplemented = Date()
    }
    
    var formattedSavingsAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: potentialSavingsAmount)) ?? "$0.00"
    }
}

// MARK: - Sample Data
extension SavingOpportunity {
    static var sampleOpportunities: [SavingOpportunity] = [
        SavingOpportunity(
            title: "Review Subscriptions",
            description: "Identify and cancel unused subscription services to reduce monthly expenses.",
            potentialSavingsAmount: 50.0,
            category: .subscriptions,
            timeframe: .immediate
        ),
        SavingOpportunity(
            title: "Switch to Energy-Efficient Appliances",
            description: "Replace old appliances with energy-efficient models to reduce utility bills.",
            potentialSavingsAmount: 200.0,
            category: .utilities,
            timeframe: .mediumTerm
        ),
        SavingOpportunity(
            title: "Meal Planning",
            description: "Plan weekly meals and grocery shopping to reduce food waste and dining out expenses.",
            potentialSavingsAmount: 150.0,
            category: .food,
            timeframe: .shortTerm
        )
    ]
} 