import SwiftUI

/// A view for managing application settings and preferences.
/// This view provides users with access to:
/// - App appearance settings (dark mode, theme)
/// - Notification preferences
/// - Data management options
/// - App information and version
///
/// The view is organized into logical sections using SwiftUI's Form component,
/// making it easy to navigate and manage different settings.
struct SettingsView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    
    /// User preferences stored in UserDefaults
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                // Appearance section
                Section(header: Text(LocalizationKey.settingsAppearance.localized)) {
                    Toggle(LocalizationKey.settingsDarkMode.localized, isOn: $darkModeEnabled)
                }
                
                // Notifications section
                Section(header: Text(LocalizationKey.settingsNotifications.localized)) {
                    Toggle(LocalizationKey.settingsEnableNotifications.localized, isOn: $notificationsEnabled)
                }
                
                // Data section
                Section(header: Text(LocalizationKey.settingsData.localized)) {
                    Button(LocalizationKey.settingsExportData.localized) {
                        // TODO: Implement data export
                    }
                    
                    Button(LocalizationKey.settingsClearCache.localized) {
                        // TODO: Implement cache clearing
                    }
                }
                
                // About section
                Section(header: Text(LocalizationKey.settingsAbout.localized)) {
                    HStack {
                        Text(LocalizationKey.settingsVersion.localized)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(LocalizationKey.settingsPrivacyPolicy.localized) {
                        Text(LocalizationKey.settingsPrivacyPolicyContent.localized)
                    }
                    
                    NavigationLink(LocalizationKey.settingsTermsOfService.localized) {
                        Text(LocalizationKey.settingsTermsOfServiceContent.localized)
                    }
                }
                
                Section(header: Text("settings.language".localized)) {
                    Picker("settings.language".localized, selection: $localizationManager.selectedLanguage) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(header: Text("settings.currency".localized)) {
                    Picker("settings.currency".localized, selection: $localizationManager.selectedCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text("\(currency.symbol) (\(currency.rawValue))")
                                .tag(currency)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("settings.title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("button.done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Preview provider for SettingsView
#Preview {
    SettingsView()
        .environmentObject(LocalizationManager.shared)
} 