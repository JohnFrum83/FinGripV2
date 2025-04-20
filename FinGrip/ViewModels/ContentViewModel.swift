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
    /// Published property that tracks whether the user has completed onboarding
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            // Persist the onboarding status when it changes
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    /// Published property that tracks whether the app is showing the splash screen
    @Published var isShowingSplash: Bool
    
    /// Published property that tracks the user's selected goals
    @Published var selectedGoals: Set<Goal>
    
    /// Published property that tracks all financial goals
    @Published var goals: [Goal]
    
    /// Published property that tracks all financial transactions
    @Published var transactions: [Transaction]
    
    /// Published property that tracks available challenges
    @Published var challenges: [Challenge]
    
    /// Initializes the view model and loads any saved state
    init() {
        // Load saved onboarding status or default to false
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        // Initialize with splash screen visible
        self.isShowingSplash = true
        
        // Initialize empty collections
        self.selectedGoals = []
        self.goals = []
        self.transactions = []
        self.challenges = []
        
        // Load any saved data
        loadSavedData()
    }
    
    /// Loads any previously saved app data from persistent storage
    private func loadSavedData() {
        // TODO: Implement data loading from UserDefaults or Core Data
    }
    
    /// Saves the current app state to persistent storage
    private func saveData() {
        // TODO: Implement data saving to UserDefaults or Core Data
    }
    
    func toggleChallengeCompletion(for challenge: Challenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isCompleted.toggle()
        }
    }
    
    func addChallenge(_ challenge: Challenge) {
        challenges.append(challenge)
    }
    
    func removeChallenge(at indexSet: IndexSet) {
        challenges.remove(atOffsets: indexSet)
    }
} 