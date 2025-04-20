import SwiftUI

/// A view that displays and manages the user's financial transactions.
/// This view provides:
/// - A list of all transactions
/// - Filtering and sorting options
/// - Transaction details
/// - Ability to add new transactions
///
/// The view uses a List to display transactions and provides
/// navigation to add new transactions or view transaction details.
struct TransactionsView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(contentViewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .onDelete(perform: deleteTransactions)
            }
            .navigationTitle(LocalizationKey.transactionsTitle.localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(transactions: $contentViewModel.transactions)
            }
        }
    }
    
    private func deleteTransactions(at offsets: IndexSet) {
        contentViewModel.transactions.remove(atOffsets: offsets)
    }
}

/// Preview provider for TransactionsView
#Preview {
    TransactionsView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 