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
        let income = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return income - expenses
    }
    
    /// Computed property for total income
    private var income: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    /// Computed property for total expenses
    private var expenses: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    /// Sample transactions for development and preview
    @State private var transactions: [Transaction] = [
        Transaction(title: "Salary", amount: 5000, category: .income, type: .income),
        Transaction(title: "Rent", amount: 1200, category: .spending, type: .expense),
        Transaction(title: "Groceries", amount: 300, category: .spending, type: .expense)
    ]
    
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
            .navigationTitle(NSLocalizedString("home.title", comment: "Home screen title"))
            .sheet(isPresented: $showingScoreDetails) {
                ScoreDetailsView(
                    score: 75, // Sample score, replace with actual score from viewModel
                    categoryScores: [
                        .savings: 70,
                        .debt: 80,
                        .spending: 75,
                        .income: 75
                    ],
                    recommendations: [
                        "Consider increasing your emergency fund",
                        "Look for ways to reduce monthly expenses",
                        "Set up automatic savings transfers"
                    ]
                )
            }
            .sheet(isPresented: $showingQuickWin) {
                QuickWinView(navigationPath: $navigationPath)
            }
        }
    }
    
    /// Balance card view showing total balance, income, and expenses
    private var balanceCard: some View {
        VStack(spacing: 15) {
            Text(NSLocalizedString("home.total_balance", comment: "Total balance label"))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("$\(balance, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold))
            
            HStack(spacing: 40) {
                VStack {
                    Text(NSLocalizedString("home.income", comment: "Income label"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("$\(income, specifier: "%.2f")")
                        .foregroundColor(.green)
                }
                
                VStack {
                    Text(NSLocalizedString("home.expenses", comment: "Expenses label"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("$\(expenses, specifier: "%.2f")")
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
                title: NSLocalizedString("home.quick_actions.score", comment: "View score action"),
                icon: "chart.bar.fill",
                action: { showingScoreDetails = true }
            )
            quickActionButton(
                title: NSLocalizedString("home.quick_actions.quick_win", comment: "Quick win action"),
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
            Text(NSLocalizedString("home.active_challenges", comment: "Active challenges section title"))
                .font(.headline)
            
            ForEach(viewModel.challenges.prefix(3)) { challenge in
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
                    
                    Text("\(challenge.points)pts")
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