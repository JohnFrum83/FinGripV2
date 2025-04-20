import SwiftUI

/// The main tab-based navigation interface for the app.
/// This view serves as the primary container for the app's main features,
/// organizing them into distinct tabs for easy access.
///
/// Features:
/// - Home tab: Overview of financial status and quick actions
/// - Goals tab: Financial goals tracking and management
/// - Transactions tab: List and management of income/expenses
/// - Analytics tab: Financial insights and reports
/// - Profile tab: User settings and preferences
struct DashboardTabView: View {
    /// Currently selected tab
    @State private var selectedTab = 0
    
    /// The main view model shared across tabs
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home tab with financial overview
            HomeView()
                .tabItem {
                    Label(
                        NSLocalizedString("tab.home", comment: "Home tab label"),
                        systemImage: "house.fill"
                    )
                }
                .tag(0)
            
            // Goals tracking and management
            GoalsView()
                .tabItem {
                    Label(
                        NSLocalizedString("tab.goals", comment: "Goals tab label"),
                        systemImage: "target"
                    )
                }
                .tag(1)
            
            // Transaction history and management
            TransactionsView()
                .tabItem {
                    Label(
                        NSLocalizedString("tab.transactions", comment: "Transactions tab label"),
                        systemImage: "list.bullet"
                    )
                }
                .tag(2)
            
            // Financial analytics and insights
            AnalyticsView()
                .tabItem {
                    Label(
                        NSLocalizedString("tab.analytics", comment: "Analytics tab label"),
                        systemImage: "chart.bar.fill"
                    )
                }
                .tag(3)
            
            // User profile and settings
            ProfileView()
                .tabItem {
                    Label(
                        NSLocalizedString("tab.profile", comment: "Profile tab label"),
                        systemImage: "person.fill"
                    )
                }
                .tag(4)
        }
        .environmentObject(viewModel) // Share view model across all tabs
    }
}

/// Preview provider for DashboardTabView
#Preview {
    DashboardTabView()
} 