import Foundation

enum LocalizationKey: String {
    // Onboarding
    case onboardingWelcomeTitle = "onboarding.welcome.title"
    case onboardingWelcomeSubtitle = "onboarding.welcome.subtitle"
    
    // Buttons
    case buttonGetStarted = "button.get_started"
    case buttonComplete = "button.complete"
    case buttonSelectBank = "button.select_bank"
    
    // Common
    case welcome = "welcome"
    case settings = "settings"
    case profile = "profile"
    case language = "language"
    case currency = "currency"
    case save = "save"
    case cancel = "cancel"
    
    // Profile
    case profileTitle = "profile.title"
    case profileSectionAccount = "profile.section.account"
    case profileAccountDetails = "profile.account.details"
    case profileAccountBank = "profile.account.bank"
    case profileSectionPreferences = "profile.section.preferences"
    case profilePreferencesLanguage = "profile.preferences.language"
    case profilePreferencesCurrency = "profile.preferences.currency"
    case profilePreferencesDarkMode = "profile.preferences.darkMode"
    case profileLanguage = "profile.language"
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
    
    // Overview
    case overviewTitle = "overview.title"
    case overviewBalance = "overview.balance"
    case overviewRecentTransactions = "overview.recent_transactions"
    case overviewGoals = "overview.goals"
    case overviewSpendingCategories = "overview.spending_categories"
    
    // General
    case appName = "app.name"
    
    // Settings
    case settingsAppearance = "settings.appearance"
    case settingsDarkMode = "settings.darkmode"
    case settingsTitle = "settings.title"
    case settingsLanguage = "settings.language"
    case settingsCurrency = "settings.currency"
    case settingsNotifications = "settings.notifications"
    case settingsEnableNotifications = "settings.notifications.enable"
    case settingsData = "settings.data"
    case settingsExportData = "settings.data.export"
    case settingsClearCache = "settings.data.clear_cache"
    case settingsAbout = "settings.about"
    case settingsVersion = "settings.version"
    case settingsPrivacyPolicy = "settings.privacy_policy"
    case settingsPrivacyPolicyContent = "settings.privacy_policy.content"
    case settingsTermsOfService = "settings.terms_of_service"
    case settingsTermsOfServiceContent = "settings.terms_of_service.content"
    
    // Navigation
    case tabHome = "tab.home"
    case tabDashboard = "tab.dashboard"
    case tabTransactions = "tab.transactions"
    case tabGoals = "tab.goals"
    case tabAnalytics = "tab.analytics"
    case tabProfile = "tab.profile"
    
    // Subscriptions
    case subscriptionsTitle = "subscriptions.title"
    case subscriptionAddTitle = "subscription.add.title"
    case subscriptionEditTitle = "subscription.edit.title"
    case subscriptionDetailsTitle = "subscription.details.title"
    case subscriptionName = "subscription.name"
    case subscriptionAmount = "subscription.amount"
    case subscriptionCategoryTitle = "subscription.category.title"
    case subscriptionCategory = "subscription.category"
    case subscriptionBillingTitle = "subscription.billing.title"
    case subscriptionBillingCycle = "subscription.billing.cycle"
    case subscriptionNotesTitle = "subscription.notes.title"
    
    // Common Actions
    case edit = "edit"
    case delete = "delete"
    
    // Goals
    case goalOverdue = "goal.overdue"
    case goalDaysLeft = "goal.days_left"
    case goalActive = "goal.active"
    
    // Transactions
    case transactionNew = "transaction.new"
    case transactionDetails = "transaction.details"
    case transactionAmount = "transaction.amount"
    
    // Analytics
    case analyticsTotalSpent = "analytics.total_spent"
    case analyticsIncome = "analytics.income"
    case analyticsExpenses = "analytics.expenses"
    
    // Goal related keys
    case goalNew = "goal.new"
    case goalDetails = "goal.details"
    case goalTitle = "goal.title"
    case goalTargetAmount = "goal.target_amount"
    case goalAmount = "goal.amount"
    case goalCancel = "goal.cancel"
    case goalDeadline = "goal.deadline"
    case goalCategory = "goal.category"
    case goalIcon = "goal.icon"
    case goalAdd = "goal.add"
    
    // Error messages
    case errorEmptyTitle = "error.empty_title"
    case errorTitleTooShort = "error.title_too_short"
    case errorInvalidAmount = "error.invalid_amount"
    case errorNegativeAmount = "error.negative_amount"
    case errorAmountTooLarge = "error.amount_too_large"
    case errorPastDeadline = "error.past_deadline"
    case errorDeadlineTooFar = "error.deadline_too_far"
    case errorValidationFailed = "error.validation_failed"
    
    // Common
    case ok = "common.ok"
    
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self.rawValue)
    }
} 