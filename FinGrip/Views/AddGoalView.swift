import SwiftUI
import Foundation

/// A view for creating new financial goals.
/// This view presents a form that allows users to:
/// - Set a goal title
/// - Define target amount
/// - Set deadline
/// - Choose an icon
/// - Save or cancel the goal creation
///
/// The view uses a binding to the goals array to add new goals directly
/// to the parent view's state.
struct AddGoalView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    /// Binding to the array of goals in the parent view
    @Binding var goals: [Goal]
    
    // Form state
    /// Title of the new goal
    @State private var title = ""
    /// Target amount for the goal
    @State private var targetAmount = ""
    /// Deadline for achieving the goal
    @State private var deadline = Date()
    /// Selected category for the goal
    @State private var category = FinancialCategory.savings
    /// Selected icon for the goal
    @State private var icon = "banknote"
    
    /// Available icons for goal representation
    private let icons = ["banknote", "car", "airplane", "house", "gift", "cart", "creditcard", "dollarsign.circle"]
    
    /// Validation state for the form
    private var isFormValid: Bool {
        !title.isEmpty && 
        Double(targetAmount) != nil && 
        Double(targetAmount)! > 0 &&
        deadline > Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic information section
                Section(header: Text(LocalizationKey.goalDetails.localized)) {
                    TextField(LocalizationKey.goalTitle.localized, text: $title)
                    
                    HStack {
                        Text(LocalizationKey.goalTargetAmount.localized)
                        Spacer()
                        TextField(LocalizationKey.goalAmount.localized, text: $targetAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker(LocalizationKey.goalDeadline.localized, selection: $deadline, displayedComponents: .date)
                }
                
                // Category selection section
                Section(header: Text(LocalizationKey.goalCategory.localized)) {
                    Picker(LocalizationKey.goalCategory.localized, selection: $category) {
                        ForEach(FinancialCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                }
                
                // Icon selection section
                Section(header: Text(LocalizationKey.goalIcon.localized)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(icons, id: \.self) { iconName in
                                Image(systemName: iconName)
                                    .font(.title2)
                                    .padding()
                                    .background(icon == iconName ? Color.accentColor : Color.clear)
                                    .foregroundColor(icon == iconName ? .white : .primary)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        icon = iconName
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle(LocalizationKey.goalNew.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizationKey.goalCancel.localized) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizationKey.goalAdd.localized) {
                        addGoal()
                    }
                    .disabled(title.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }
    
    /// Creates and saves a new goal with the current form values
    private func addGoal() {
        guard let amount = Double(targetAmount) else { return }
        
        let newGoal = Goal(
            title: title,
            targetAmount: amount,
            currentAmount: 0,
            deadline: deadline,
            category: category,
            icon: icon
        )
        
        goals.append(newGoal)
        dismiss()
    }
}

/// Preview provider for AddGoalView
#Preview {
    AddGoalView(goals: .constant([]))
} 