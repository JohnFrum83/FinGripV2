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
    
    // Validation state
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    @State private var fieldInError: FormField?
    @State private var isShaking = false
    @State private var showSuccessAnimation = false
    
    /// Available icons for goal representation
    private let icons = ["banknote", "car", "airplane", "house", "gift", "cart", "creditcard", "dollarsign.circle"]
    
    /// Enum to track which field has an error
    private enum FormField {
        case title
        case amount
        case deadline
    }
    
    /// Validation state for the form
    private var isFormValid: Bool {
        validateForm().0
    }
    
    /// Validates the form and returns a tuple of (isValid, errorMessage, fieldInError)
    private func validateForm() -> (Bool, String, FormField?) {
        // Title validation
        if title.isEmpty {
            return (false, LocalizationKey.errorEmptyTitle.localized, .title)
        }
        if title.count < 3 {
            return (false, LocalizationKey.errorTitleTooShort.localized, .title)
        }
        
        // Amount validation
        guard let amount = Double(targetAmount) else {
            return (false, LocalizationKey.errorInvalidAmount.localized, .amount)
        }
        if amount <= 0 {
            return (false, LocalizationKey.errorNegativeAmount.localized, .amount)
        }
        if amount > 1_000_000_000 { // Reasonable upper limit
            return (false, LocalizationKey.errorAmountTooLarge.localized, .amount)
        }
        
        // Deadline validation
        if deadline <= Date() {
            return (false, LocalizationKey.errorPastDeadline.localized, .deadline)
        }
        if deadline > Calendar.current.date(byAdding: .year, value: 30, to: Date())! {
            return (false, LocalizationKey.errorDeadlineTooFar.localized, .deadline)
        }
        
        return (true, "", nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic information section
                Section(header: Text(LocalizationKey.goalDetails.localized)) {
                    TextField(LocalizationKey.goalTitle.localized, text: $title)
                        .modifier(ValidationModifier(isShaking: isShaking && fieldInError == .title))
                        .foregroundColor(fieldInError == .title ? .red : .primary)
                        .onChange(of: title) { _ in
                            fieldInError = nil
                        }
                    
                    HStack {
                        Text(LocalizationKey.goalTargetAmount.localized)
                        Spacer()
                        TextField(LocalizationKey.goalAmount.localized, text: $targetAmount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .modifier(ValidationModifier(isShaking: isShaking && fieldInError == .amount))
                            .foregroundColor(fieldInError == .amount ? .red : .primary)
                            .onChange(of: targetAmount) { _ in
                                fieldInError = nil
                            }
                    }
                    
                    DatePicker(LocalizationKey.goalDeadline.localized, selection: $deadline, displayedComponents: .date)
                        .modifier(ValidationModifier(isShaking: isShaking && fieldInError == .deadline))
                        .foregroundColor(fieldInError == .deadline ? .red : .primary)
                        .onChange(of: deadline) { _ in
                            fieldInError = nil
                        }
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
                                    .scaleEffect(icon == iconName ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: icon == iconName)
                                    .onTapGesture {
                                        withAnimation {
                                            icon = iconName
                                        }
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
                        validateAndAddGoal()
                    }
                }
            }
            .alert(isPresented: $showingValidationAlert) {
                Alert(
                    title: Text(LocalizationKey.errorValidationFailed.localized),
                    message: Text(validationMessage),
                    dismissButton: .default(Text(LocalizationKey.ok.localized))
                )
            }
            .overlay(
                ZStack {
                    if showSuccessAnimation {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        showSuccessAnimation = false
                                        dismiss()
                                    }
                                }
                            }
                    }
                }
            )
        }
    }
    
    /// Validates the form and adds the goal if validation passes
    private func validateAndAddGoal() {
        let (isValid, message, field) = validateForm()
        
        if !isValid {
            validationMessage = message
            fieldInError = field
            showingValidationAlert = true
            withAnimation(.default) {
                isShaking = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isShaking = false
            }
            return
        }
        
        guard let amount = Double(targetAmount) else { return }
        
        let newGoal = Goal(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            targetAmount: amount,
            currentAmount: 0,
            deadline: deadline,
            category: category,
            icon: icon
        )
        
        withAnimation {
            showSuccessAnimation = true
            goals.append(newGoal)
        }
    }
}

/// A view modifier that adds a shaking animation for validation feedback
struct ValidationModifier: ViewModifier {
    let isShaking: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: isShaking ? 5 : 0)
            .animation(
                isShaking ?
                    .spring(response: 0.1, dampingFraction: 0.2).repeatCount(3) :
                    nil,
                value: isShaking
            )
    }
}

/// Preview provider for AddGoalView
#Preview {
    AddGoalView(goals: .constant([]))
} 