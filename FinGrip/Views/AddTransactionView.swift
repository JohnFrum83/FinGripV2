import SwiftUI

/// A view for creating new financial transactions.
/// This view presents a form that allows users to:
/// - Specify transaction amount
/// - Select transaction type (income/expense)
/// - Choose a category
/// - Add a description
/// - Set the date
/// - Choose an icon
///
/// The view uses a binding to the transactions array to add new transactions
/// directly to the parent view's state.
struct AddTransactionView: View {
    /// Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    /// Binding to the array of transactions in the parent view
    @Binding var transactions: [Transaction]
    
    // Form state
    /// Transaction amount
    @State private var amount = ""
    /// Transaction type (income/expense)
    @State private var type: TransactionType = .expense
    /// Transaction category
    @State private var category: FinancialCategory = .spending
    /// Transaction description
    @State private var description = ""
    /// Transaction date
    @State private var date = Date()
    /// Selected icon for the transaction
    @State private var selectedIcon = "dollarsign.circle"
    
    /// Available transaction categories
    private let categories: [FinancialCategory] = [
        .savings, .debt, .spending, .income
    ]
    
    /// Available icons for transaction representation
    private let availableIcons = [
        "dollarsign.circle", "cart", "house", "car",
        "airplane", "heart", "book", "bag"
    ]
    
    /// Validation state for the form
    private var isFormValid: Bool {
        !description.isEmpty &&
        Double(amount) != nil &&
        Double(amount)! > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic information section
                Section(header: Text(LocalizationKey.transactionDetails.localized)) {
                    TextField(LocalizationKey.transactionAmount.localized, text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker(LocalizationKey.transactionType.localized, selection: $type) {
                        Text(LocalizationKey.transactionIncome.localized).tag(TransactionType.income)
                        Text(LocalizationKey.transactionExpense.localized).tag(TransactionType.expense)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker(LocalizationKey.transactionCategory.localized, selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    
                    TextField(LocalizationKey.transactionDescription.localized, text: $description)
                    DatePicker(LocalizationKey.transactionDate.localized, selection: $date, displayedComponents: .date)
                }
                
                // Icon selection section
                Section(header: Text(LocalizationKey.transactionIcon.localized)) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .foregroundColor(selectedIcon == icon ? .blue : .gray)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(selectedIcon == icon ? Color.blue.opacity(0.2) : Color.clear)
                                )
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                }
            }
            .navigationTitle(LocalizationKey.transactionNew.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizationKey.transactionCancel.localized) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizationKey.transactionSave.localized) {
                        saveTransaction()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    /// Creates and saves a new transaction with the current form values
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let newTransaction = Transaction(
            title: description,
            amount: amountValue,
            category: category,
            date: date,
            type: type
        )
        
        transactions.append(newTransaction)
        dismiss()
    }
}

/// Preview provider for AddTransactionView
#Preview {
    AddTransactionView(transactions: .constant([]))
} 