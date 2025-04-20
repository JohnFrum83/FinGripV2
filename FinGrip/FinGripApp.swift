import SwiftUI

@main
struct FinGripApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    
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
        
        // Load the Resources bundle and initialize localization
        guard let resourcePath = Bundle.main.path(forResource: "Resources", ofType: "bundle"),
              let resourceBundle = Bundle(path: resourcePath),
              let languagePath = resourceBundle.path(forResource: languageCode, ofType: "lproj"),
              let languageBundle = Bundle(path: languagePath) else {
            print("⚠️ Failed to load language bundle for: \(languageCode)")
            return
        }
        
        // Force the bundle to be reloaded
        let _ = languageBundle.localizedString(forKey: "app.name", value: nil, table: "Localizable")
        print("✅ Successfully loaded language bundle for: \(languageCode)")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.locale, Locale(identifier: localizationManager.selectedLanguage.rawValue))
                .environmentObject(localizationManager)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LocalizationManager.shared)
} 