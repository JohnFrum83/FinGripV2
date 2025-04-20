import SwiftUI

/// The main dashboard view that serves as the root of the application.
/// This view manages the tab-based navigation and displays:
/// - Overview tab with financial summary
/// - Transactions tab for managing financial records
/// - Goals tab for tracking financial objectives
/// - Profile tab for user settings and account management
///
/// The view uses a TabView to organize different sections of the app
/// and provides a consistent navigation experience.
struct DashboardTabView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        TabView {
            OverviewView()
                .tabItem {
                    Label(LocalizationKey.tabOverview.localized, systemImage: "chart.bar.fill")
                }
            
            TransactionsView()
                .tabItem {
                    Label(LocalizationKey.tabTransactions.localized, systemImage: "list.bullet")
                }
            
            GoalsView()
                .tabItem {
                    Label(LocalizationKey.tabGoals.localized, systemImage: "target")
                }
            
            ProfileView()
                .tabItem {
                    Label(LocalizationKey.tabProfile.localized, systemImage: "person.fill")
                }
        }
    }
}

/// Preview provider for DashboardTabView
#Preview {
    DashboardTabView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
}

struct ProfileView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("biometricEnabled") private var biometricEnabled = false
    
    var body: some View {
        NavigationView {
            List {
                // ACCOUNT section
                Section(header: Text("profile.section.account".localized)) {
                    NavigationLink {
                        Text("Account Details")
                    } label: {
                        Label {
                            Text("profile.account.details".localized)
                        } icon: {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    NavigationLink {
                        Text("Bank Connection")
                    } label: {
                        Label {
                            Text("profile.account.bank".localized)
                        } icon: {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // PREFERENCES section
                Section(header: Text("profile.section.preferences".localized)) {
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        HStack {
                            Text("profile.preferences.language".localized)
                            Spacer()
                            Text(localizationManager.selectedLanguage.displayName)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink {
                        CurrencySelectionView()
                    } label: {
                        HStack {
                            Text("profile.preferences.currency".localized)
                            Spacer()
                            Text("\(localizationManager.selectedCurrency.symbol) (\(localizationManager.selectedCurrency.rawValue))")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Toggle("profile.preferences.dark_mode".localized, isOn: $darkModeEnabled)
                }
                
                // DATA section
                Section(header: Text("profile.section.data".localized)) {
                    Button("profile.data.export".localized) {
                        // TODO: Implement data export
                    }
                    
                    Button("profile.data.clear_cache".localized) {
                        // TODO: Implement cache clearing
                    }
                }
                
                // NOTIFICATIONS section
                Section(header: Text("profile.section.notifications".localized)) {
                    Toggle("profile.notifications.enabled".localized, isOn: $notificationsEnabled)
                    
                    NavigationLink {
                        Text("Notification Preferences")
                    } label: {
                        Text("profile.notifications.preferences".localized)
                    }
                }
                
                // SECURITY section
                Section(header: Text("profile.section.security".localized)) {
                    Toggle("profile.security.biometric".localized, isOn: $biometricEnabled)
                    
                    NavigationLink {
                        Text("Privacy Settings")
                    } label: {
                        Text("profile.security.privacy".localized)
                    }
                }
                
                // HELP section
                Section(header: Text("profile.section.help".localized)) {
                    NavigationLink {
                        Text("FAQ")
                    } label: {
                        Label {
                            Text("profile.help.faq".localized)
                        } icon: {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    NavigationLink {
                        Text("Support")
                    } label: {
                        Label {
                            Text("profile.help.support".localized)
                        } icon: {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // ABOUT section
                Section(header: Text("profile.section.about".localized)) {
                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Text("profile.about.terms".localized)
                    }
                    
                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Text("profile.about.privacy".localized)
                    }
                    
                    HStack {
                        Text("profile.about.version".localized)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("profile.title".localized)
        }
    }
}

struct LanguageSelectionView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(Language.allCases) { language in
                Button(action: {
                    localizationManager.selectedLanguage = language
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(language.displayName)
                        Spacer()
                        if language == localizationManager.selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("profile.preferences.language".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CurrencySelectionView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(Currency.allCases) { currency in
                Button(action: {
                    localizationManager.selectedCurrency = currency
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("\(currency.symbol) (\(currency.rawValue))")
                        Spacer()
                        if currency == localizationManager.selectedCurrency {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("profile.preferences.currency".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
} 