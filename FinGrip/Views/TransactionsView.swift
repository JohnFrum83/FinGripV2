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
        Transaction(date: Date(), amount: 5000, type: .income, category: .income, description: "Salary", merchant: "Employer Inc."),
        Transaction(date: Date(), amount: 1200, type: .expense, category: .housing, description: "Rent", merchant: "Property Management"),
        Transaction(date: Date(), amount: 300, type: .expense, category: .food, description: "Groceries", merchant: "Local Market"),
        Transaction(date: Date(), amount: 1000, type: .expense, category: .savings, description: "Monthly Savings", merchant: "Bank"),
        Transaction(date: Date(), amount: 500, type: .expense, category: .debt, description: "Credit Card Payment", merchant: "Credit Bank")
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
            .navigationTitle("transactions.title".localized)
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
            Text("transactions.filter.all".localized)
                .tag(0)
            Text("transactions.filter.income".localized)
                .tag(1)
            Text("transactions.filter.expenses".localized)
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
                title: "transactions.summary.income".localized,
                amount: transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount },
                color: .green
            )
            
            // Expenses summary card
            summaryCard(
                title: "transactions.summary.expenses".localized,
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
            
            Text(amount.currencyFormatted())
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