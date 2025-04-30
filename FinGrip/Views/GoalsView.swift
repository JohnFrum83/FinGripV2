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
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
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
                .padding(.horizontal, 8)
            }
            .navigationTitle("goals.title".localized)
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
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: goal.icon)
                    .font(.title3)
                    .foregroundColor(goal.category.color)
                    .frame(width: 20)
                
                Text(goal.title)
                    .font(.callout.bold())
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 4)
            }
            
            Text(goal.category.displayName)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text(goal.deadline, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer(minLength: 4)
            
            HStack(spacing: 8) {
                ProgressView(value: goal.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(goal.category.color)
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 35, alignment: .trailing)
            }
        }
        .padding(10)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}

/// Preview provider for GoalsView
#Preview {
    GoalsView()
        .environmentObject(ContentViewModel())
} 