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
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationView {
            List {
                accountSection
                preferencesSection
                notificationsSection
                securitySection
                helpSection
                aboutSection
            }
            .navigationTitle(LocalizationKey.profileTitle.localized)
        }
    }
    
    /// Section displaying user account information and bank connections
    private var accountSection: some View {
        Section(header: Text(LocalizationKey.profileSectionAccount.localized)) {
            NavigationLink(destination: AccountDetailsView()) {
                Text(LocalizationKey.profileAccountDetails.localized)
            }
            NavigationLink(destination: SyncBankView(navigationPath: $navigationPath)) {
                Text(LocalizationKey.profileAccountBank.localized)
            }
        }
    }
    
    /// Section for managing app preferences including currency and theme
    private var preferencesSection: some View {
        Section(header: Text(LocalizationKey.profileSectionPreferences.localized)) {
            NavigationLink(destination: LanguageSettingsView()) {
                Text(LocalizationKey.profilePreferencesLanguage.localized)
            }
            NavigationLink(destination: CurrencySettingsView()) {
                Text(LocalizationKey.profilePreferencesCurrency.localized)
            }
            Toggle(LocalizationKey.profilePreferencesDarkMode.localized, isOn: $viewModel.isDarkMode)
        }
    }
    
    /// Section for configuring notification settings
    private var notificationsSection: some View {
        Section(header: Text(LocalizationKey.profileSectionNotifications.localized)) {
            Toggle(LocalizationKey.profileNotificationsEnabled.localized, isOn: $viewModel.notificationsEnabled)
            if viewModel.notificationsEnabled {
                NavigationLink(destination: NotificationPreferencesView()) {
                    Text(LocalizationKey.profileNotificationsPreferences.localized)
                }
            }
        }
    }
    
    /// Section for managing security features and privacy settings
    private var securitySection: some View {
        Section(header: Text(LocalizationKey.profileSectionSecurity.localized)) {
            Toggle(LocalizationKey.profileSecurityBiometric.localized, isOn: $viewModel.biometricEnabled)
            NavigationLink(destination: PrivacySettingsView()) {
                Text(LocalizationKey.profileSecurityPrivacy.localized)
            }
        }
    }
    
    /// Section providing access to help and support resources
    private var helpSection: some View {
        Section(header: Text(LocalizationKey.profileSectionHelp.localized)) {
            NavigationLink(destination: FAQView()) {
                Text(LocalizationKey.profileHelpFaq.localized)
            }
            NavigationLink(destination: SupportView()) {
                Text(LocalizationKey.profileHelpSupport.localized)
            }
        }
    }
    
    /// Section displaying app information and legal documents
    private var aboutSection: some View {
        Section(header: Text(LocalizationKey.profileSectionAbout.localized)) {
            NavigationLink(destination: TermsView()) {
                Text(LocalizationKey.profileAboutTerms.localized)
            }
            NavigationLink(destination: PrivacyPolicyView()) {
                Text(LocalizationKey.profileAboutPrivacy.localized)
            }
            HStack {
                Text(LocalizationKey.profileAboutVersion.localized)
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// Preview provider for ProfileView
#Preview {
    ProfileView()
} 