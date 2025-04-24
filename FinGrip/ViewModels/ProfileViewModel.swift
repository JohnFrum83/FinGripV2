import SwiftUI

class ProfileViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode = false
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @AppStorage("biometricEnabled") var biometricEnabled = false
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    // MARK: - Methods
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
        // TODO: Implement notification permission handling
    }
    
    func toggleBiometric() {
        biometricEnabled.toggle()
        // TODO: Implement biometric authentication setup
    }
} 