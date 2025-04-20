import Foundation
import SwiftUI

/// Enum defining all localization keys used in the application
enum LocalizationKey: String, CaseIterable {
    // MARK: - General
    case appName = "app.name"
    case buttonNext = "button.next"
    case buttonFinish = "button.finish"
    case buttonBack = "button.back"
    case buttonConnect = "button.connect"
    case buttonGetStarted = "button.get_started"
    case buttonComplete = "button.complete"
    case buttonSelectBank = "button.select_bank"
    case buttonDone = "button.done"
    
    // MARK: - Analytics
    case analyticsTitle = "analytics.title"
    case analyticsPeriodWeek = "analytics.period.week"
    case analyticsPeriodMonth = "analytics.period.month"
    case analyticsExpenses = "analytics.expenses"
    case analyticsIncome = "analytics.income"
    case analyticsBalance = "analytics.balance"
    case analyticsNoData = "analytics.no_data"
    
    // MARK: - Navigation
    case tabHome = "tab.home"
    case tabGoals = "tab.goals"
    case tabAnalytics = "tab.analytics"
    case tabProfile = "tab.profile"
    case tabTransactions = "tab.transactions"
    case tabBudget = "tab.budget"
    
    // MARK: - Profile
    case profileTitle = "profile.title"
    case profileSectionAccount = "profile.section.account"
    case profileAccountDetails = "profile.account.details"
    case profileAccountBank = "profile.account.bank"
    case profileSectionPreferences = "profile.section.preferences"
    case profilePreferencesLanguage = "profile.preferences.language"
    case profilePreferencesCurrency = "profile.preferences.currency"
    case profilePreferencesDarkMode = "profile.preferences.dark_mode"
    case profileSectionNotifications = "profile.section.notifications"
    case profileNotificationsEnabled = "profile.notifications.enabled"
    case profileNotificationsPreferences = "profile.notifications.preferences"
    case profileSectionSecurity = "profile.section.security"
    case profileSecurityBiometric = "profile.security.biometric"
    case profileSecurityPrivacy = "profile.security.privacy"
    case profileSectionHelp = "profile.section.help"
    case profileHelpFaq = "profile.help.faq"
    case profileHelpSupport = "profile.help.support"
    case profileSectionAbout = "profile.section.about"
    case profileAboutTerms = "profile.about.terms"
    case profileAboutPrivacy = "profile.about.privacy"
    case profileAboutVersion = "profile.about.version"
    
    // MARK: - Onboarding
    case onboardingWelcomeTitle = "onboarding.welcome.title"
    case onboardingWelcomeSubtitle = "onboarding.welcome.subtitle"
    case onboardingWelcomeCurrency = "onboarding.welcome.currency"
    case onboardingBankTitle = "onboarding.bank.title"
    case onboardingBankSubtitle = "onboarding.bank.subtitle"
    case onboardingBankDescription = "onboarding.bank.description"
    case onboardingGoalsTitle = "onboarding.goals.title"
    case onboardingGoalsSubtitle = "onboarding.goals.subtitle"
    case onboardingAnalysisTitle = "onboarding.analysis.title"
    case onboardingAnalysisProcessing = "onboarding.analysis.processing"
    case onboardingAnalysisBank = "onboarding.analysis.bank"
    case onboardingAnalysisTransactions = "onboarding.analysis.transactions"
    case onboardingAnalysisGoals = "onboarding.analysis.goals"
    case onboardingAnalysisPlan = "onboarding.analysis.plan"
    case onboardingScoreTitle = "onboarding.score.title"
    case onboardingScoreReady = "onboarding.score.ready"
    case onboardingScoreDescription = "onboarding.score.description"
    case onboardingQuickWinTitle = "onboarding.quickwin.title"
    case onboardingQuickWinSubtitle = "onboarding.quickwin.subtitle"
    case onboardingQuickWinItem1 = "onboarding.quickwin.item1"
    case onboardingQuickWinItem2 = "onboarding.quickwin.item2"
    case onboardingQuickWinItem3 = "onboarding.quickwin.item3"
    
    /// Returns the localized string for the key
    var localized: String {
        // Get the bundle containing our Resources
        let bundle = Bundle(for: LocalizationManager.self)
        let value = NSLocalizedString(self.rawValue, value: self.rawValue, table: "Localizable", bundle: bundle, comment: "")
        if value == self.rawValue {
            print("⚠️ Warning: Missing translation for key: \(self.rawValue)")
        }
        return value
    }
}

/// Manages localization settings and provides localized strings for the application
class LocalizationManager: ObservableObject {
    /// Shared instance for app-wide access
    static let shared = LocalizationManager()
    
    /// Currently selected language
    @AppStorage("selectedLanguage") var selectedLanguage: Language = .english {
        didSet {
            objectWillChange.send()
            updateLanguage()
        }
    }
    
    @AppStorage("selectedCurrency") var selectedCurrency: Currency = .usd {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {
        // Set initial language if not set
        if UserDefaults.standard.string(forKey: "AppleLanguages") == nil {
            UserDefaults.standard.set([selectedLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        
        // Ensure the Resources bundle is loaded
        if let resourcePath = Bundle.main.path(forResource: "Resources", ofType: "bundle"),
           let resourceBundle = Bundle(path: resourcePath) {
            print("✅ Successfully loaded Resources bundle")
        } else {
            print("⚠️ Failed to load Resources bundle")
        }
    }
    
    /// Updates the app's language based on the selected language
    private func updateLanguage() {
        // Update the system language
        UserDefaults.standard.set([selectedLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Reset the main bundle to use the new language
        if let resourcePath = Bundle.main.path(forResource: "Resources", ofType: "bundle"),
           let resourceBundle = Bundle(path: resourcePath),
           let languagePath = resourceBundle.path(forResource: selectedLanguage.rawValue, ofType: "lproj"),
           let languageBundle = Bundle(path: languagePath) {
            // Force the bundle to be reloaded
            if let _ = languageBundle.localizedString(forKey: "app.name", value: nil, table: "Localizable") {
                print("✅ Successfully switched to language: \(selectedLanguage.rawValue)")
            }
        } else {
            print("⚠️ Failed to switch to language: \(selectedLanguage.rawValue)")
        }
        
        // Force update views that depend on localization
        objectWillChange.send()
        
        // Post notification for views to update
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    
    func localizedString(_ key: String) -> String {
        let value = NSLocalizedString(key, value: key, table: "Localizable", bundle: .main, comment: "")
        if value == key {
            print("⚠️ Warning: Missing translation for key: \(key)")
        }
        return value
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = selectedCurrency.symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(selectedCurrency.symbol)\(amount)"
    }
}

// MARK: - String Extension
extension String {
    var localized: String {
        let value = NSLocalizedString(self, value: self, table: "Localizable", bundle: .main, comment: "")
        if value == self {
            print("⚠️ Warning: Missing translation for key: \(self)")
        }
        return value
    }
    
    func localizedFormat(_ args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
}

// MARK: - Double Extension
extension Double {
    var currencyFormatted: String {
        return LocalizationManager.shared.formatCurrency(self)
    }
    
    var asCurrency: String {
        return LocalizationManager.shared.formatCurrency(self)
    }
}

// MARK: - Supported languages in the application
enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case polish = "pl"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .polish:
            return "Polski"
        }
    }
}

// MARK: - Supported currencies in the application
enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case pln = "PLN"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .pln: return "zł"
        }
    }
}

// MARK: - View Extension for Previews
extension View {
    func previewWithLocalizations() -> some View {
        ForEach(Language.allCases, id: \.rawValue) { language in
            self
                .environment(\.locale, .init(identifier: language.rawValue))
                .environmentObject(LocalizationManager.shared)
                .previewDisplayName(language.rawValue)
        }
    }
} 