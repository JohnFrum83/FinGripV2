import Foundation
import SwiftUI

/// The main view model that manages the app's state and business logic.
/// This class is responsible for coordinating between views and models,
/// handling data persistence, and managing the app's navigation flow.
///
/// Usage example:
/// ```swift
/// @StateObject private var viewModel = ContentViewModel()
/// ```
@MainActor
class ContentViewModel: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @Published var isShowingSplash = true
    
    // Account
    @Published var currentBalance: Double = 0.0
    
    // Goals
    @Published var selectedGoals: Set<UUID> = []
    @Published var goals: [Goal] = []
    
    // Transactions
    @Published var transactions: [Transaction] = []
    
    // Spending Categories
    @Published var spendingCategories: [SpendingCategory] = []
    
    /// Returns the 5 most recent transactions
    var recentTransactions: [Transaction] {
        Array(transactions.sorted { $0.date > $1.date }.prefix(5))
    }
    
    // Challenges
    @Published var challenges: [Challenge] = []
    
    // Subscriptions
    @Published var subscriptions: [Subscription] = []
    
    // Financial Health
    @Published var healthScore: FinancialHealthScore = FinancialHealthScore()
    @Published var scoreHistory: [FinancialHealthScore] = []
    
    // Savings
    @Published var totalSaved: Double = 0
    @Published var savingsTracker: SavingsTracker = SavingsTracker()
    
    init() {
        loadData()
        calculateFinancialScore()
        spendingCategories = SpendingCategory.defaultCategories
    }
    
    func loadData() {
        // TODO: Implement data loading from persistence
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Initial balance
        currentBalance = 2500.0
        
        // Sample goals
        goals = [
            Goal(title: "Emergency Fund", targetAmount: 5000, deadline: Date().addingTimeInterval(180*24*60*60), category: .savings, icon: "banknote"),
            Goal(title: "Pay off Credit Card", targetAmount: 2000, deadline: Date().addingTimeInterval(90*24*60*60), category: .debt, icon: "creditcard"),
            Goal(title: "Vacation Savings", targetAmount: 3000, deadline: Date().addingTimeInterval(365*24*60*60), category: .savings, icon: "airplane")
        ]
        
        // Sample transactions
        transactions = [
            Transaction(date: Date(), amount: 1000, type: .income, category: .income, description: "Salary", merchant: "Employer Inc."),
            Transaction(date: Date(), amount: 50, type: .expense, category: .food, description: "Groceries", merchant: "Local Market")
        ]
        
        // Sample challenges
        challenges = [
            Challenge(
                title: "Save $100 this week",
                description: "Put aside $100 from your income",
                category: .savings,
                reward: 100.0,
                duration: 7,
                difficulty: .medium,
                points: 100,
                isCompleted: false,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                steps: [
                    "Track your daily expenses",
                    "Identify non-essential spending",
                    "Set aside money each day",
                    "Reach the $100 goal"
                ]
            ),
            Challenge(
                title: "Review your budget",
                description: "Check your monthly spending",
                category: .spending,
                reward: 50.0,
                duration: 1,
                difficulty: .easy,
                points: 100,
                isCompleted: false,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                steps: [
                    "Review last month's expenses",
                    "Categorize your spending",
                    "Identify areas for improvement",
                    "Set new budget goals"
                ]
            ),
            Challenge(
                title: "Budgeting Challenge",
                description: "Save $100 in 30 days",
                category: .savings,
                reward: 100.0,
                duration: 30,
                difficulty: .medium,
                points: 200,
                isCompleted: false,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
                steps: [
                    "Track your daily expenses",
                    "Identify areas for improvement",
                    "Set aside money each day",
                    "Reach the $100 goal"
                ]
            )
        ]
        
        // Sample subscriptions
        subscriptions = [
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
            )
        ]
    }
    
    // MARK: - Goals Management
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func removeGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
    
    func updateGoalProgress(_ goal: Goal, amount: Double) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].currentAmount += amount
        }
    }
    
    // MARK: - Challenges Management
    
    func toggleChallengeCompletion(_ challenge: Challenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isCompleted.toggle()
        }
    }
    
    func addChallenge(_ challenge: Challenge) {
        challenges.append(challenge)
    }
    
    func removeChallenge(_ challenge: Challenge) {
        challenges.removeAll { $0.id == challenge.id }
    }
    
    // MARK: - Subscriptions Management
    
    func addSubscription(_ subscription: Subscription) {
        subscriptions.append(subscription)
        saveSubscriptions()
    }
    
    func updateSubscription(_ subscription: Subscription) {
        if let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) {
            subscriptions[index] = subscription
            saveSubscriptions()
        }
    }
    
    func deleteSubscription(_ subscription: Subscription) {
        subscriptions.removeAll { $0.id == subscription.id }
        saveSubscriptions()
    }
    
    private func saveSubscriptions() {
        do {
            let data = try JSONEncoder().encode(subscriptions)
            UserDefaults.standard.set(data, forKey: "subscriptions")
        } catch {
            print("Error saving subscriptions: \(error)")
        }
    }
    
    private func loadSubscriptions() {
        if let data = UserDefaults.standard.data(forKey: "subscriptions") {
            do {
                subscriptions = try JSONDecoder().decode([Subscription].self, from: data)
            } catch {
                print("Error loading subscriptions: \(error)")
                subscriptions = []
            }
        }
    }
    
    var unusedSubscriptions: [Subscription] {
        subscriptions.filter { $0.isUnused }
    }
    
    func subscriptionsByCategory(_ category: Subscription.SubscriptionCategory) -> [Subscription] {
        subscriptions.filter { $0.category == category }
    }
    
    // MARK: - Financial Health Score
    
    func calculateFinancialScore() {
        let components = [
            FinancialHealthScore.ScoreComponent(
                category: .savings,
                score: calculateSavingsScore(),
                details: "Based on savings rate and emergency fund"
            ),
            FinancialHealthScore.ScoreComponent(
                category: .debt,
                score: calculateDebtScore(),
                details: "Based on debt-to-income ratio"
            ),
            FinancialHealthScore.ScoreComponent(
                category: .spending,
                score: calculateSpendingScore(),
                details: "Based on spending patterns"
            ),
            FinancialHealthScore.ScoreComponent(
                category: .investments,
                score: calculateInvestmentScore(),
                details: "Based on investment diversification"
            ),
            FinancialHealthScore.ScoreComponent(
                category: .protection,
                score: calculateProtectionScore(),
                details: "Based on insurance and emergency fund"
            )
        ]
        
        healthScore = FinancialHealthScore(components: components)
        scoreHistory.append(healthScore)
    }
    
    private func calculateSavingsScore() -> Double {
        // TODO: Implement savings score calculation
        return 75.0
    }
    
    private func calculateDebtScore() -> Double {
        // TODO: Implement debt score calculation
        return 80.0
    }
    
    private func calculateSpendingScore() -> Double {
        // TODO: Implement spending score calculation
        return 70.0
    }
    
    private func calculateInvestmentScore() -> Double {
        // TODO: Implement investment score calculation
        return 65.0
    }
    
    private func calculateProtectionScore() -> Double {
        // TODO: Implement protection score calculation
        return 85.0
    }
    
    // MARK: - Savings Tracking
    
    func implementSaving(_ opportunity: SavingOpportunity, savedAmount: Double) {
        if let index = savingsTracker.opportunities.firstIndex(where: { $0.id == opportunity.id }) {
            var updatedOpportunity = opportunity
            updatedOpportunity.isImplemented = true
            savingsTracker.opportunities[index] = updatedOpportunity
            
            let implementedSaving = ImplementedSaving(
                opportunity: updatedOpportunity,
                amount: savedAmount
            )
            savingsTracker.implementedSavings.append(implementedSaving)
            savingsTracker.totalSaved += savedAmount
            totalSaved += savedAmount
        }
    }
} 