import SwiftUI
import Foundation

/// A reusable view component that displays a single financial goal.
/// This view is used in lists and grids throughout the app to show:
/// - Goal title and icon
/// - Current progress towards the target amount
/// - Visual progress indicator
/// - Time remaining until deadline
///
/// Usage example:
/// ```swift
/// GoalRow(goal: goalItem)
///     .padding()
///     .background(Color(.systemBackground))
/// ```
struct GoalRow: View {
    /// The goal to display
    let goal: Goal
    
    /// Formatted remaining time until deadline
    private var timeRemaining: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: goal.deadline)
        guard let days = components.day, days > 0 else { return LocalizationKey.goalOverdue.localized }
        return String(format: LocalizationKey.goalDaysLeft.localized, days)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Goal header with icon and title
            HStack {
                Image(systemName: goal.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                    Text(timeRemaining)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress section
            VStack(alignment: .leading, spacing: 8) {
                // Amount progress
                HStack {
                    Text("$\(goal.currentAmount, specifier: "%.2f")")
                        .font(.subheadline)
                    Text("/ $\(goal.targetAmount, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.2))
                            .frame(height: 8)
                        
                        // Progress indicator
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * goal.progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
    }
}

/// Preview provider for GoalRow
#Preview {
    GoalRow(goal: Goal(
        title: "Emergency Fund",
        targetAmount: 10000,
        currentAmount: 2500,
        deadline: Date().addingTimeInterval(365*24*60*60),
        category: .savings,
        icon: "banknote"
    ))
    .padding()
    .previewLayout(.sizeThatFits)
} 