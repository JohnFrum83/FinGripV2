import SwiftUI

/// View for managing and displaying financial transactions.
/// This view provides a comprehensive interface for:
/// - Viewing all financial transactions
/// - Filtering transactions by type (income/expense)
/// - Adding new transactions
/// - Analyzing transaction history
///
/// The view uses a segmented control to switch between different
/// transaction types and displays them in a scrollable list.
struct TransactionsView: View {
    /// Access to the shared view model
    @EnvironmentObject private var viewModel: ContentViewModel
    
    /// Currently selected transaction type filter
    @State private var selectedFilter = 0
    
    /// State for showing the add transaction sheet
    @State private var showingAddTransaction = false
    
    /// Sample transactions for development and preview
    @State private var transactions: [Transaction] = [
        Transaction(title: "Salary", amount: 5000, category: .income, type: .income),
        Transaction(title: "Rent", amount: 1200, category: .spending, type: .expense),
        Transaction(title: "Groceries", amount: 300, category: .spending, type: .expense),
        Transaction(title: "Savings", amount: 1000, category: .savings, type: .expense),
        Transaction(title: "Credit Card Payment", amount: 500, category: .debt, type: .expense)
    ]
    
    /// Filtered transactions based on selected type
    private var filteredTransactions: [Transaction] {
        switch selectedFilter {
        case 0: return transactions // All transactions
        case 1: return transactions.filter { $0.type == .income }
        case 2: return transactions.filter { $0.type == .expense }
        default: return transactions
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Transaction type filter
                filterPicker
                
                // Transaction summary cards
                summaryCards
                
                // List of transactions
                transactionsList
            }
            .navigationTitle(NSLocalizedString("transactions.title", comment: "Transactions screen title"))
            .toolbar {
                Button(action: { showingAddTransaction = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(transactions: $transactions)
            }
        }
    }
    
    /// Segmented control for filtering transactions
    private var filterPicker: some View {
        Picker("", selection: $selectedFilter) {
            Text(NSLocalizedString("transactions.filter.all", comment: "All transactions filter"))
                .tag(0)
            Text(NSLocalizedString("transactions.filter.income", comment: "Income filter"))
                .tag(1)
            Text(NSLocalizedString("transactions.filter.expenses", comment: "Expenses filter"))
                .tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    /// Cards showing transaction totals
    private var summaryCards: some View {
        HStack(spacing: 15) {
            // Income summary card
            summaryCard(
                title: NSLocalizedString("transactions.summary.income", comment: "Income summary title"),
                amount: transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount },
                color: .green
            )
            
            // Expenses summary card
            summaryCard(
                title: NSLocalizedString("transactions.summary.expenses", comment: "Expenses summary title"),
                amount: transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount },
                color: .red
            )
        }
        .padding(.horizontal)
    }
    
    /// Individual summary card view
    private func summaryCard(title: String, amount: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// List of filtered transactions
    private var transactionsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

/// Preview provider for TransactionsView
#Preview {
    TransactionsView()
        .environmentObject(ContentViewModel())
} 