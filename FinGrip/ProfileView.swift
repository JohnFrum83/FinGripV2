import SwiftUI

/// A comprehensive view for managing user profile and application settings.
/// This view provides a centralized interface for users to:
/// - View and edit their account information
/// - Manage app preferences including currency and theme
/// - Configure notification settings
/// - Set up security features
/// - Access help and support resources
/// - View app information and legal documents
///
/// The view is organized into logical sections using SwiftUI's List and Section components,
/// making it easy to navigate and manage different aspects of the app.
struct ProfileView: View {
    /// Access to the shared view model for app-wide state management
    @EnvironmentObject private var viewModel: ContentViewModel
    
    /// Access to the localization manager
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    /// User preferences stored in UserDefaults
    @AppStorage("selectedCurrency") private var selectedCurrency = "USD"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("biometricEnabled") private var biometricEnabled = false
    
    /// Available currency options for the user to choose from
    private let currencies = ["USD", "EUR", "GBP", "PLN"]
    
    var body: some View {
        NavigationView {
            List {
                // Account section for managing user profile and bank connections
                accountSection
                
                // Preferences section for app customization
                preferencesSection
                
                // Notifications section for managing alerts and reminders
                notificationsSection
                
                // Security section for authentication and privacy settings
                securitySection
                
                // Help & Support section for user assistance
                helpSection
                
                // About section for app information and legal documents
                aboutSection
            }
            .navigationTitle(LocalizationKey.profileTitle.localized)
        }
    }
    
    /// Section displaying user account information and bank connections
    private var accountSection: some View {
        Section(header: Text(LocalizationKey.profileSectionAccount.localized)) {
            NavigationLink(destination: Text("Account Details")) {
                Label(
                    LocalizationKey.profileAccountDetails.localized,
                    systemImage: "person.circle"
                )
            }
            
            NavigationLink(destination: Text("Bank Connections")) {
                Label(
                    LocalizationKey.profileAccountBank.localized,
                    systemImage: "building.columns"
                )
            }
        }
    }
    
    /// Section for managing app preferences including currency and theme
    private var preferencesSection: some View {
        Section(header: Text(LocalizationKey.profileSectionPreferences.localized)) {
            Picker(
                LocalizationKey.profilePreferencesLanguage.localized,
                selection: $localizationManager.selectedLanguage
            ) {
                ForEach(Language.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            
            Picker(
                LocalizationKey.profilePreferencesCurrency.localized,
                selection: $selectedCurrency
            ) {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency).tag(currency)
                }
            }
            
            Toggle(
                LocalizationKey.profilePreferencesDarkMode.localized,
                isOn: $darkModeEnabled
            )
        }
    }
    
    /// Section for configuring notification settings
    private var notificationsSection: some View {
        Section(header: Text(LocalizationKey.profileSectionNotifications.localized)) {
            Toggle(
                LocalizationKey.profileNotificationsEnabled.localized,
                isOn: $notificationsEnabled
            )
            
            if notificationsEnabled {
                NavigationLink(destination: Text("Notification Preferences")) {
                    Text(LocalizationKey.profileNotificationsPreferences.localized)
                }
            }
        }
    }
    
    /// Section for managing security features and privacy settings
    private var securitySection: some View {
        Section(header: Text(LocalizationKey.profileSectionSecurity.localized)) {
            Toggle(
                LocalizationKey.profileSecurityBiometric.localized,
                isOn: $biometricEnabled
            )
            
            NavigationLink(destination: Text("Privacy Settings")) {
                Text(LocalizationKey.profileSecurityPrivacy.localized)
            }
        }
    }
    
    /// Section providing access to help and support resources
    private var helpSection: some View {
        Section(header: Text(LocalizationKey.profileSectionHelp.localized)) {
            NavigationLink(destination: Text("FAQ")) {
                Label(
                    LocalizationKey.profileHelpFaq.localized,
                    systemImage: "questionmark.circle"
                )
            }
            
            NavigationLink(destination: Text("Contact Support")) {
                Label(
                    LocalizationKey.profileHelpSupport.localized,
                    systemImage: "envelope"
                )
            }
        }
    }
    
    /// Section displaying app information and legal documents
    private var aboutSection: some View {
        Section(header: Text(LocalizationKey.profileSectionAbout.localized)) {
            NavigationLink(destination: Text("Terms of Service")) {
                Text(LocalizationKey.profileAboutTerms.localized)
            }
            
            NavigationLink(destination: Text("Privacy Policy")) {
                Text(LocalizationKey.profileAboutPrivacy.localized)
            }
            
            HStack {
                Text(LocalizationKey.profileAboutVersion.localized)
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// Preview provider for ProfileView
#Preview {
    ProfileView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 