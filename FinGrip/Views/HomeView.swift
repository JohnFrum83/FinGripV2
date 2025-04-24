import SwiftUI

/// The main dashboard view showing an overview of the user's financial status.
/// This view presents key financial information and quick actions, including:
/// - Current balance
/// - Recent income and expenses
/// - Financial health score
/// - Quick access to common actions
/// - Active financial challenges
struct HomeView: View {
    /// Access to the shared view model
    @EnvironmentObject private var viewModel: ContentViewModel
    
    /// State for showing the score details sheet
    @State private var showingScoreDetails = false
    
    /// State for showing the quick win sheet
    @State private var showingQuickWin = false
    
    /// State for managing navigation
    @State private var navigationPath = NavigationPath()
    
    /// Computed property for total balance
    private var balance: Double {
        viewModel.currentBalance
    }
    
    /// Computed property for total income
    private var income: Double {
        viewModel.transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    /// Computed property for total expenses
    private var expenses: Double {
        viewModel.transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance card showing current financial status
                    balanceCard
                    
                    // Quick actions grid
                    quickActionsGrid
                    
                    // Active challenges section
                    challengesSection
                }
                .padding()
            }
            .navigationTitle("home.title".localized)
            .sheet(isPresented: $showingScoreDetails) {
                FinancialScoreDetailsView(contentViewModel: viewModel)
            }
            .sheet(isPresented: $showingQuickWin) {
                QuickWinView(navigationPath: $navigationPath)
            }
        }
    }
    
    /// Balance card view showing total balance, income, and expenses
    private var balanceCard: some View {
        VStack(spacing: 15) {
            Text("home.total_balance".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(balance.currencyFormatted())
                .font(.system(size: 34, weight: .bold))
            
            HStack(spacing: 40) {
                VStack {
                    Text("home.income".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(income.currencyFormatted())
                        .foregroundColor(.green)
                }
                
                VStack {
                    Text("home.expenses".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(expenses.currencyFormatted())
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    /// Grid of quick action buttons
    private var quickActionsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            quickActionButton(
                title: "home.quick_actions.score".localized,
                icon: "chart.bar.fill",
                action: { showingScoreDetails = true }
            )
            quickActionButton(
                title: "home.quick_actions.quick_win".localized,
                icon: "star.fill",
                action: { showingQuickWin = true }
            )
        }
    }
    
    /// Individual quick action button
    private func quickActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
    
    /// Section showing active financial challenges
    private var challengesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("home.active_challenges".localized)
                .font(.headline)
            
            ForEach(viewModel.challenges.prefix(3).map { $0 }, id: \.self) { (challenge: Challenge) in
                HStack {
                    Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(challenge.isCompleted ? .green : .gray)
                    
                    VStack(alignment: .leading) {
                        Text(challenge.title)
                            .font(.subheadline)
                        Text(challenge.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "points.format".localized, challenge.points))
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 2)
            }
        }
    }
}

/// Preview provider for HomeView
#Preview {
    HomeView()
        .environmentObject(ContentViewModel())
} 