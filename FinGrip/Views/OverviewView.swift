import SwiftUI

/// A view that provides an overview of the user's financial status.
/// This view displays:
/// - Current balance
/// - Recent transactions
/// - Financial goals progress
/// - Spending categories breakdown
///
/// The view uses charts and lists to present financial data in an
/// easily digestible format.
struct OverviewView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Balance Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizationKey.overviewBalance.localized)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(contentViewModel.currentBalance.currencyFormatted())
                        .font(.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Recent Transactions Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(LocalizationKey.overviewRecentTransactions.localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        NavigationLink("See All") {
                            TransactionsView()
                        }
                        .font(.subheadline)
                    }
                    
                    ForEach(contentViewModel.recentTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Goals Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(LocalizationKey.overviewGoals.localized)
                            .font(.headline)
                        
                        Spacer()
                        
                        NavigationLink("See All") {
                            GoalsView()
                        }
                        .font(.subheadline)
                    }
                    
                    ForEach($contentViewModel.goals) { $goal in
                        GoalRow(goal: goal)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Spending Categories Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizationKey.overviewSpendingCategories.localized)
                        .font(.headline)
                    
                    ForEach($contentViewModel.spendingCategories) { $category in
                        HStack {
                            Text($category.name.wrappedValue)
                            Spacer()
                            Text("$\($category.currentSpending.wrappedValue, specifier: "%.2f")")
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle(LocalizationKey.overviewTitle.localized)
        .background(Color(.systemGroupedBackground))
    }
}

/// Preview provider for OverviewView
#Preview {
    OverviewView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 