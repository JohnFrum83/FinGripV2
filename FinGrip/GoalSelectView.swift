import SwiftUI
import Foundation

struct GoalSelectView: View {
    @Binding var selectedGoals: Set<Goal>
    @State private var showingAddGoal = false
    @State private var goals: [Goal] = []
    @Environment(\.dismiss) var dismiss
    
    let presetGoals = [
        Goal(title: NSLocalizedString("goals.preset.emergency_fund", comment: "Emergency fund goal"),
             targetAmount: 10000,
             currentAmount: 0,
             deadline: Date().addingTimeInterval(365*24*60*60),
             category: .savings,
             icon: "banknote"),
        Goal(title: NSLocalizedString("goals.preset.new_car", comment: "New car goal"),
             targetAmount: 25000,
             currentAmount: 0,
             deadline: Date().addingTimeInterval(730*24*60*60),
             category: .savings,
             icon: "car"),
        Goal(title: NSLocalizedString("goals.preset.vacation", comment: "Vacation goal"),
             targetAmount: 5000,
             currentAmount: 0,
             deadline: Date().addingTimeInterval(180*24*60*60),
             category: .spending,
             icon: "airplane"),
        Goal(title: NSLocalizedString("goals.preset.home_renovation", comment: "Home renovation goal"),
             targetAmount: 15000,
             currentAmount: 0,
             deadline: Date().addingTimeInterval(365*24*60*60),
             category: .spending,
             icon: "house"),
        Goal(title: NSLocalizedString("goals.preset.education", comment: "Education goal"),
             targetAmount: 20000,
             currentAmount: 0,
             deadline: Date().addingTimeInterval(1095*24*60*60),
             category: .savings,
             icon: "graduationcap")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text(NSLocalizedString("goals.select.title", comment: "Select goals title"))
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(NSLocalizedString("goals.select.subtitle", comment: "Select goals subtitle"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                List {
                    ForEach(presetGoals, id: \.id) { goal in
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
                                Text("\(NSLocalizedString("goals.target.prefix", comment: "Target prefix"))\(String(format: "%.2f", goal.targetAmount))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: selectedGoals.contains(goal) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedGoals.contains(goal) ? .blue : .gray)
                                .font(.title2)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                VStack(spacing: 12) {
                    Button(action: { showingAddGoal = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text(NSLocalizedString("goals.add.button", comment: "Add custom goal button"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if !selectedGoals.isEmpty {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Text(NSLocalizedString("goals.continue.button", comment: "Continue button"))
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedGoals.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(selectedGoals.isEmpty)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle(NSLocalizedString("goals.title", comment: "Goals"))
            .toolbar {
                Button(action: { showingAddGoal = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals)
            }
        }
    }
}

#Preview {
    GoalSelectView(selectedGoals: Binding.constant([]))
} 