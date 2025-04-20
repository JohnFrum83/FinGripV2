import Foundation
import SwiftUI

enum Currency: String, CaseIterable, Identifiable {
    case eur = "EUR"
    case usd = "USD"
    case pln = "PLN"
    case gbp = "GBP"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .eur: return "€"
        case .usd: return "$"
        case .pln: return "zł"
        case .gbp: return "£"
        }
    }
}

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case polish = "pl"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .polish: return "Polski"
        }
    }
}

class LocalizationManager: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: Language = .english
    @AppStorage("selectedCurrency") var selectedCurrency: Currency = .usd
    
    static let shared = LocalizationManager()
    
    private init() {
        print("LocalizationManager initialized with language: \(selectedLanguage.rawValue)")
    }
    
    func localizedString(_ key: String) -> String {
        let value = NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: key, comment: "")
        print("Localizing key: \(key), got value: \(value)")
        if value == key {
            print("⚠️ Warning: Translation missing for key: \(key)")
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
        return LocalizationManager.shared.localizedString(self)
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

// MARK: - LocalizationKey
enum LocalizationKey {
    // Analytics
    static let analyticsTitle = "analytics.title"
    static let analyticsPeriodWeek = "analytics.period.week"
    static let analyticsPeriodMonth = "analytics.period.month"
    static let analyticsPeriodYear = "analytics.period.year"
    static let analyticsSummarySavings = "analytics.summary.savings"
    static let analyticsSummarySpending = "analytics.summary.spending"
    static let analyticsChartIncome = "analytics.chart.income"
    static let analyticsChartExpenses = "analytics.chart.expenses"
    static let analyticsChartTransactions = "analytics.chart.transactions"
    static let analyticsChartPlaceholder = "analytics.chart.placeholder"
    
    // Navigation
    static let tabHome = "tab.home"
    static let tabGoals = "tab.goals"
    static let tabTransactions = "tab.transactions"
    static let tabAnalytics = "tab.analytics"
    static let tabProfile = "tab.profile"
    static let tabBudget = "tab.budget"
    
    // Onboarding
    static let onboardingWelcomeTitle = "onboarding.welcome.title"
    static let onboardingWelcomeSubtitle = "onboarding.welcome.subtitle"
    static let onboardingWelcomeCurrency = "onboarding.welcome.currency"
    static let onboardingBankTitle = "onboarding.bank.title"
    static let onboardingBankSubtitle = "onboarding.bank.subtitle"
    static let onboardingBankDescription = "onboarding.bank.description"
    static let onboardingBankSelect = "onboarding.bank.select"
    static let onboardingGoalsTitle = "onboarding.goals.title"
    static let onboardingGoalsSubtitle = "onboarding.goals.subtitle"
    static let onboardingGoalsEmergency = "onboarding.goals.emergency"
    static let onboardingGoalsEmergencyDesc = "onboarding.goals.emergency.desc"
    static let onboardingGoalsDebt = "onboarding.goals.debt"
    static let onboardingGoalsDebtDesc = "onboarding.goals.debt.desc"
    static let onboardingGoalsInvest = "onboarding.goals.invest"
    static let onboardingGoalsInvestDesc = "onboarding.goals.invest.desc"
    static let onboardingGoalsBudget = "onboarding.goals.budget"
    static let onboardingGoalsBudgetDesc = "onboarding.goals.budget.desc"
    static let onboardingAnalysisTitle = "onboarding.analysis.title"
    static let onboardingAnalysisProcessing = "onboarding.analysis.processing"
    static let onboardingAnalysisBank = "onboarding.analysis.bank"
    static let onboardingAnalysisTransactions = "onboarding.analysis.transactions"
    static let onboardingAnalysisGoals = "onboarding.analysis.goals"
    static let onboardingAnalysisPlan = "onboarding.analysis.plan"
    
    // Score
    static let onboardingScoreTitle = "onboarding.score.title"
    static let onboardingScoreCalculating = "onboarding.score.calculating"
    static let onboardingScoreReady = "onboarding.score.ready"
    static let onboardingScoreDescription = "onboarding.score.description"
    static let onboardingScoreSavings = "onboarding.score.savings"
    static let onboardingScoreDebt = "onboarding.score.debt"
    static let onboardingScoreSpending = "onboarding.score.spending"
    static let onboardingScoreIncome = "onboarding.score.income"
    static let onboardingScoreImprove = "onboarding.score.improve"
    
    // Quick Wins
    static let onboardingQuickWinTitle = "onboarding.quickwin.title"
    static let onboardingQuickWinSubtitle = "onboarding.quickwin.subtitle"
    static let onboardingQuickWinItem1 = "onboarding.quickwin.item1"
    static let onboardingQuickWinItem2 = "onboarding.quickwin.item2"
    static let onboardingQuickWinItem3 = "onboarding.quickwin.item3"
    
    // Buttons
    static let buttonNext = "button.next"
    static let buttonBack = "button.back"
    static let buttonGetStarted = "button.get_started"
    static let buttonComplete = "button.complete"
    static let buttonConnect = "button.connect"
    static let buttonSelectBank = "button.select_bank"
    static let buttonFinish = "button.finish"
    
    // App
    static let appName = "app.name"
    
    // Profile
    static let profileTitle = "profile.title"
    static let profileSectionAccount = "profile.section.account"
    static let profileAccountDetails = "profile.account.details"
    static let profileAccountBank = "profile.account.bank"
    static let profileSectionPreferences = "profile.section.preferences"
    static let profilePreferencesLanguage = "profile.preferences.language"
    static let profilePreferencesCurrency = "profile.preferences.currency"
    static let profilePreferencesDarkMode = "profile.preferences.darkmode"
    static let profileSectionNotifications = "profile.section.notifications"
    static let profileNotificationsEnabled = "profile.notifications.enabled"
    static let profileNotificationsPreferences = "profile.notifications.preferences"
    static let profileSectionSecurity = "profile.section.security"
    static let profileSecurityBiometric = "profile.security.biometric"
    static let profileSecurityPrivacy = "profile.security.privacy"
    static let profileSectionHelp = "profile.section.help"
    static let profileHelpFaq = "profile.help.faq"
    static let profileHelpSupport = "profile.help.support"
    static let profileSectionAbout = "profile.section.about"
    static let profileAboutTerms = "profile.about.terms"
    static let profileAboutPrivacy = "profile.about.privacy"
    static let profileAboutVersion = "profile.about.version"
    static let profileSignOut = "profile.signout"
    
    // Transaction
    static let transactionDetails = "transaction.details"
    static let transactionAmount = "transaction.amount"
    static let transactionType = "transaction.type"
    static let transactionIncome = "transaction.income"
    static let transactionExpense = "transaction.expense"
    static let transactionCategory = "transaction.category"
    static let transactionDescription = "transaction.description"
    static let transactionDate = "transaction.date"
    static let transactionIcon = "transaction.icon"
    static let transactionNew = "transaction.new"
    static let transactionCancel = "transaction.cancel"
    static let transactionSave = "transaction.save"
    
    // Goal
    static let goalDetails = "goal.details"
    static let goalTitle = "goal.title"
    static let goalTargetAmount = "goal.target_amount"
    static let goalAmount = "goal.amount"
    static let goalDeadline = "goal.deadline"
    static let goalCategory = "goal.category"
    static let goalIcon = "goal.icon"
    static let goalNew = "goal.new"
    static let goalCancel = "goal.cancel"
    static let goalAdd = "goal.add"
    static let goalOverdue = "goal.overdue"
    static let goalDaysLeft = "goal.days_left"
    
    // Score
    static let scoreDetails = "score.details"
    static let scoreRecommendations = "score.recommendations"
    static let scoreNeedsImprovement = "score.needs_improvement"
    static let scoreFair = "score.fair"
    static let scoreGood = "score.good"
    static let scoreExcellent = "score.excellent"
    
    // Settings
    static let settingsAppearance = "settings.appearance"
    static let settingsDarkMode = "settings.dark_mode"
    static let settingsNotifications = "settings.notifications"
    static let settingsEnableNotifications = "settings.enable_notifications"
    static let settingsData = "settings.data"
    static let settingsExportData = "settings.export_data"
    static let settingsClearCache = "settings.clear_cache"
    static let settingsAbout = "settings.about"
    static let settingsVersion = "settings.version"
    static let settingsPrivacyPolicy = "settings.privacy_policy"
    static let settingsTermsOfService = "settings.terms_of_service"
    static let settingsPrivacyPolicyContent = "settings.privacy_policy_content"
    static let settingsTermsOfServiceContent = "settings.terms_of_service_content"
}

// MARK: - View Extension for Previews
extension View {
    func previewWithLocalizations() -> some View {
        ForEach(Language.allCases, id: \.rawValue) { language in
            self
                .environment(\.locale, .init(identifier: language.rawValue))
                .previewDisplayName(language.rawValue)
        }
    }
} 