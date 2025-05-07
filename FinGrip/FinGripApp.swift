import SwiftUI

@main
struct FinGripApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var tinkService = TinkService.shared
    
    init() {
        // Set initial language if not already set
        if UserDefaults.standard.string(forKey: "selectedLanguage") == nil {
            UserDefaults.standard.set(Language.english.rawValue, forKey: "selectedLanguage")
        }
        
        // Get the selected language code
        let languageCode = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Language.english.rawValue
        
        // Set the user's preferred language
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.set(languageCode, forKey: "AppleLocale")
        UserDefaults.standard.synchronize()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.locale, Locale(identifier: localizationManager.selectedLanguage.rawValue))
                .environmentObject(localizationManager)
                .environmentObject(tinkService)
                .onOpenURL { url in
                    Task {
                        try? await tinkService.handleCallback(url)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                    // Force view refresh when language changes
                    print("🔄 Refreshing views after language change")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LocalizationManager.shared)
} 