import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var overallScore: Int = 0
    @Published var categoryScores: [FinancialCategory: Int] = [
        .savings: 0,
        .debt: 0,
        .spending: 0,
        .income: 0
    ]
    
    func completeOnboarding() {
        // Save onboarding completion state
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Calculate scores based on user's selections and data
        calculateScores()
    }
    
    private func calculateScores() {
        // Example scoring logic - replace with actual calculations
        categoryScores = [
            .savings: Int.random(in: 40...90),
            .debt: Int.random(in: 40...90),
            .spending: Int.random(in: 40...90),
            .income: Int.random(in: 40...90)
        ]
        
        // Calculate overall score as average
        overallScore = Int(categoryScores.values.reduce(0, +) / categoryScores.count)
    }
} 