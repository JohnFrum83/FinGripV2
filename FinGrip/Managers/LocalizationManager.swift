import Foundation
import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case polish = "pl"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .polish: return "Polski"
        }
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case eur = "EUR"
    case pln = "PLN"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .pln: return "zł"
        }
    }
}

class LocalizationManager: ObservableObject {
    @Published var selectedLanguage: Language = .english {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
            print("Language changed to: \(selectedLanguage.rawValue)")
            updateLanguageBundle()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    @Published var selectedCurrency: Currency = .eur {
        didSet {
            UserDefaults.standard.set(selectedCurrency.rawValue, forKey: "selectedCurrency")
        }
    }
    
    static let shared = LocalizationManager()
    private var languageBundle: Bundle?
    
    private init() {
        // Load saved language
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            selectedLanguage = language
        }
        
        // Load saved currency
        if let savedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency"),
           let currency = Currency(rawValue: savedCurrency) {
            selectedCurrency = currency
        }
        
        // Initialize language bundle
        updateLanguageBundle()
    }
    
    private func updateLanguageBundle() {
        let languageCode = selectedLanguage.rawValue
        print("📦 Updating language bundle for: \(languageCode)")
        
        // Print the main bundle path for debugging
        print("📍 Main bundle path: \(Bundle.main.bundlePath)")
        
        // List all resources in the bundle
        if let enumerator = FileManager.default.enumerator(atPath: Bundle.main.bundlePath) {
            print("📚 Bundle contents:")
            while let filePath = enumerator.nextObject() as? String {
                if filePath.contains(".lproj") {
                    print("   - \(filePath)")
                }
            }
        }
        
        // First try to get the language bundle directly from the main bundle
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
            print("🔍 Found lproj path: \(path)")
            if let bundle = Bundle(path: path) {
                print("✅ Successfully created bundle from path")
                languageBundle = bundle
                return
            } else {
                print("❌ Failed to create bundle from path: \(path)")
            }
        } else {
            print("❌ Could not find \(languageCode).lproj in main bundle")
        }
        
        // Try to find the Resources directory
        let resourcesPath = (Bundle.main.bundlePath as NSString).appendingPathComponent("Resources")
        print("📂 Checking Resources at: \(resourcesPath)")
        if FileManager.default.fileExists(atPath: resourcesPath) {
            print("✅ Found Resources directory")
            let lprojPath = (resourcesPath as NSString).appendingPathComponent("\(languageCode).lproj")
            print("🔍 Checking for lproj at: \(lprojPath)")
            if FileManager.default.fileExists(atPath: lprojPath) {
                print("✅ Found \(languageCode).lproj directory")
                if let bundle = Bundle(path: lprojPath) {
                    print("✅ Successfully created bundle from Resources/\(languageCode).lproj")
                    languageBundle = bundle
                    return
                } else {
                    print("❌ Failed to create bundle from path: \(lprojPath)")
                }
            } else {
                print("❌ \(languageCode).lproj directory not found in Resources")
            }
        } else {
            print("❌ Resources directory not found at: \(resourcesPath)")
        }
        
        print("❌ Could not find language bundle for: \(languageCode)")
        // Fallback to main bundle if language bundle not found
        languageBundle = Bundle.main
    }
    
    func localizedString(for key: String, comment: String = "") -> String {
        // Try to get string from language bundle
        if let bundle = languageBundle {
            let localizedString = bundle.localizedString(forKey: key, value: key, table: "Localizable")
            if localizedString != key {
                return localizedString
            }
        }
        
        // Fallback to main bundle
        let mainBundleString = Bundle.main.localizedString(forKey: key, value: key, table: "Localizable")
        if mainBundleString != key {
            return mainBundleString
        }
        
        // If no translation found, return the key
        print("⚠️ No translation found for key: \(key)")
        return key
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = selectedCurrency.rawValue
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    func formatCurrency(_ amount: Int) -> String {
        return formatCurrency(Double(amount))
    }
}

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}

extension Double {
    var formattedCurrency: String {
        return LocalizationManager.shared.formatCurrency(self)
    }
}

extension Int {
    var formattedCurrency: String {
        return LocalizationManager.shared.formatCurrency(self)
    }
} 