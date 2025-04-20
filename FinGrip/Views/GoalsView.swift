import SwiftUI

/// A view that displays and manages the user's financial goals.
/// This view provides:
/// - A list of all goals
/// - Goal progress tracking
/// - Ability to add new goals
/// - Goal details and editing
///
/// The view uses a List to display goals and provides
/// navigation to add new goals or view goal details.
struct GoalsView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(contentViewModel.goals) { goal in
                    GoalRow(goal: goal)
                }
                .onDelete(perform: deleteGoals)
            }
            .navigationTitle(LocalizationKey.goalsTitle.localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $contentViewModel.goals)
            }
        }
    }
    
    private func deleteGoals(at offsets: IndexSet) {
        contentViewModel.goals.remove(atOffsets: offsets)
    }
}

/// Preview provider for GoalsView
#Preview {
    GoalsView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 