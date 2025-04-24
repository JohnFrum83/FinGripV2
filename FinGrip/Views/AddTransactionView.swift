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
                Section(header: Text(NSLocalizedString("transaction.details", comment: "Transaction details"))) {
                    TextField(NSLocalizedString("transaction.amount", comment: "Transaction amount"), text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker(NSLocalizedString("transaction.type", comment: "Transaction type"), selection: $type) {
                        Text(NSLocalizedString("transaction.income", comment: "Income")).tag(TransactionType.income)
                        Text(NSLocalizedString("transaction.expense", comment: "Expense")).tag(TransactionType.expense)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker(NSLocalizedString("transaction.category", comment: "Transaction category"), selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    
                    TextField(NSLocalizedString("transaction.description", comment: "Transaction description"), text: $description)
                    DatePicker(NSLocalizedString("transaction.date", comment: "Transaction date"), selection: $date, displayedComponents: .date)
                }
                
                // Icon selection section
                Section(header: Text(NSLocalizedString("transaction.icon", comment: "Transaction icon"))) {
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
            .navigationTitle(NSLocalizedString("transaction.new", comment: "New transaction"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("transaction.cancel", comment: "Cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("transaction.save", comment: "Save")) {
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
            date: date,
            amount: amountValue,
            type: type,
            category: category,
            description: description
        )
        
        transactions.append(newTransaction)
        dismiss()
    }
}

/// Preview provider for AddTransactionView
#Preview {
    AddTransactionView(transactions: .constant([]))
} 