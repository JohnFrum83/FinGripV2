import SwiftUI

/// A reusable view component that displays a single financial transaction.
/// This view is used in lists throughout the app to show:
/// - Transaction title and amount
/// - Transaction category and date
/// - Visual indicators for transaction type
///
/// Usage example:
/// ```swift
/// TransactionRow(transaction: transactionItem)
///     .padding()
///     .background(Color(.systemBackground))
/// ```
struct TransactionRow: View {
    /// The transaction to display
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // Transaction icon
            Image(systemName: transaction.category.icon)
                .font(.title2)
                .foregroundColor(transaction.type == .income ? .green : .red)
                .frame(width: 40, height: 40)
                .background(transaction.type == .income ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .cornerRadius(8)
            
            // Transaction details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.headline)
                
                HStack {
                    Text(transaction.category.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(transaction.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Transaction amount
            Text(transaction.formattedAmount)
                .font(.headline)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}

/// Preview provider for TransactionRow
struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: Transaction(
            date: Date(),
            amount: 45.67,
            type: .expense,
            category: .shopping,
            description: "Grocery Shopping",
            merchant: "Whole Foods",
            location: "123 Main St, Anytown, USA"
        ))
    }
} 