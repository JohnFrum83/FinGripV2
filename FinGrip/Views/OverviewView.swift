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
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance card
                    balanceCard
                    
                    // Recent transactions
                    recentTransactionsSection
                    
                    // Goals progress
                    goalsProgressSection
                    
                    // Spending categories
                    spendingCategoriesSection
                }
                .padding()
            }
            .navigationTitle(LocalizationKey.overviewTitle.localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Implement refresh
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizationKey.overviewBalance.localized)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(contentViewModel.formattedBalance)
                .font(.system(size: 36, weight: .bold))
            
            HStack {
                Text(LocalizationKey.overviewIncome.localized)
                    .foregroundColor(.green)
                Text(contentViewModel.formattedIncome)
                    .foregroundColor(.green)
                
                Spacer()
                
                Text(LocalizationKey.overviewExpenses.localized)
                    .foregroundColor(.red)
                Text(contentViewModel.formattedExpenses)
                    .foregroundColor(.red)
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.overviewRecentTransactions.localized)
                .font(.headline)
            
            ForEach(contentViewModel.recentTransactions) { transaction in
                TransactionRow(transaction: transaction)
            }
            
            NavigationLink(destination: TransactionsView()) {
                Text(LocalizationKey.overviewViewAllTransactions.localized)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var goalsProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.overviewGoals.localized)
                .font(.headline)
            
            ForEach(contentViewModel.activeGoals) { goal in
                GoalRow(goal: goal)
            }
            
            NavigationLink(destination: GoalsView()) {
                Text(LocalizationKey.overviewViewAllGoals.localized)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var spendingCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKey.overviewSpendingCategories.localized)
                .font(.headline)
            
            ForEach(contentViewModel.spendingCategories) { category in
                HStack {
                    Text(category.name)
                    Spacer()
                    Text(category.formattedAmount)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/// Preview provider for OverviewView
#Preview {
    OverviewView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 