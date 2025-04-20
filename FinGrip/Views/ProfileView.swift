import SwiftUI

/// A view that displays and manages the user's profile information.
/// This view provides:
/// - User account information
/// - App preferences and settings
/// - Help and support options
/// - About app information
///
/// The view is organized into logical sections using SwiftUI's Form component,
/// making it easy to navigate and manage different profile settings.
struct ProfileView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var localizationManager: LocalizationManager
    @AppStorage("selectedCurrency") private var selectedCurrency = Currency.usd.rawValue
    
    var body: some View {
        NavigationView {
            Form {
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
    
    private var accountSection: some View {
        Section(header: Text(LocalizationKey.profileAccount.localized)) {
            HStack {
                Text(LocalizationKey.profileName.localized)
                Spacer()
                Text(contentViewModel.userName)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(LocalizationKey.profileEmail.localized)
                Spacer()
                Text(contentViewModel.userEmail)
                    .foregroundColor(.secondary)
            }
            
            NavigationLink(destination: LanguageSelectionView()) {
                Text(LocalizationKey.profileLanguage.localized)
            }
        }
    }
    
    private var preferencesSection: some View {
        Section(header: Text(LocalizationKey.profilePreferences.localized)) {
            Picker(LocalizationKey.profileCurrency.localized, selection: $selectedCurrency) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue).tag(currency.rawValue)
                }
            }
        }
    }
    
    private var notificationsSection: some View {
        Section(header: Text(LocalizationKey.profileNotifications.localized)) {
            Toggle(LocalizationKey.profileTransactionAlerts.localized, isOn: $contentViewModel.transactionAlertsEnabled)
            Toggle(LocalizationKey.profileGoalReminders.localized, isOn: $contentViewModel.goalRemindersEnabled)
        }
    }
    
    private var securitySection: some View {
        Section(header: Text(LocalizationKey.profileSecurity.localized)) {
            NavigationLink(destination: Text(LocalizationKey.profileChangePassword.localized)) {
                Text(LocalizationKey.profileChangePassword.localized)
            }
            
            NavigationLink(destination: Text(LocalizationKey.profileTwoFactorAuth.localized)) {
                Text(LocalizationKey.profileTwoFactorAuth.localized)
            }
        }
    }
    
    private var helpSection: some View {
        Section(header: Text(LocalizationKey.profileHelp.localized)) {
            NavigationLink(destination: Text(LocalizationKey.profileFAQ.localized)) {
                Text(LocalizationKey.profileFAQ.localized)
            }
            
            NavigationLink(destination: Text(LocalizationKey.profileContactSupport.localized)) {
                Text(LocalizationKey.profileContactSupport.localized)
            }
        }
    }
    
    private var aboutSection: some View {
        Section(header: Text(LocalizationKey.profileAbout.localized)) {
            HStack {
                Text(LocalizationKey.profileVersion.localized)
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            NavigationLink(destination: Text(LocalizationKey.profilePrivacyPolicy.localized)) {
                Text(LocalizationKey.profilePrivacyPolicy.localized)
            }
            
            NavigationLink(destination: Text(LocalizationKey.profileTermsOfService.localized)) {
                Text(LocalizationKey.profileTermsOfService.localized)
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