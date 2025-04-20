import SwiftUI

/// View for managing and tracking financial goals.
/// This view allows users to:
/// - View their current financial goals and progress
/// - Add new goals from presets or custom ones
/// - Track progress towards each goal
/// - View goal details and update progress
struct GoalsView: View {
    /// Access to the shared view model
    @EnvironmentObject private var viewModel: ContentViewModel
    
    /// State for showing the goal selection sheet
    @State private var showingAddGoal = false
    
    /// State for selected goals
    @State private var selectedGoals: Set<Goal> = []
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.goals) { goal in
                        GoalCard(goal: goal, isSelected: selectedGoals.contains(goal))
                            .onTapGesture {
                                if selectedGoals.contains(goal) {
                                    selectedGoals.remove(goal)
                                } else {
                                    selectedGoals.insert(goal)
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("goals.title", comment: "Goals screen title"))
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
                GoalSelectView(selectedGoals: $selectedGoals)
            }
        }
    }
}

struct GoalCard: View {
    let goal: Goal
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: goal.icon)
                    .font(.title2)
                    .foregroundColor(goal.category.color)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
            Text(goal.title)
                .font(.headline)
            
            Text(goal.category.displayName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: goal.progress)
                .tint(goal.category.color)
            
            HStack {
                Text("\(Int(goal.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(goal.deadline, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/// Preview provider for GoalsView
#Preview {
    GoalsView()
        .environmentObject(ContentViewModel())
} 