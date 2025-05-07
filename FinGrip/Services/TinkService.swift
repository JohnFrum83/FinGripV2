import Foundation
import SwiftUI
import os.log
import Security
import TinkLink

/// Service class for handling Tink API interactions
class TinkService: ObservableObject {
    /// Shared instance for singleton access
    static let shared = TinkService()
    
    /// Current authentication state
    @Published private(set) var authState: TinkAuthenticationState = .notAuthenticated
    
    /// Access token for authenticated requests
    private var accessToken: String?
    
    private let logger = Logger(subsystem: "com.fingrip.app", category: "TinkService")
    
    /// Test mode flag for simulation
    var isTestMode: Bool = TinkConfiguration.testMode
    
    private let tokenKey = "TinkAccessToken"
    
    private init() {}
    
    // MARK: - Authentication
    /// TODO: Implement authentication using TinkLink v4+ async/await API
    func authenticate() async throws -> String {
        // Placeholder: Simulate successful authentication and return a dummy code
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay
        return "dummy-auth-code"
    }
    
    /// Allows external code to update the authentication state safely
    func setAuthState(_ newState: TinkAuthenticationState) {
        self.authState = newState
    }
    
    /// TODO: Implement callback handler using TinkLink v4+ async/await API
    func handleCallback(_ url: URL) async throws {
        // Use TinkLink async/await methods here
    }
    
    // MARK: - Data Fetching
    /// TODO: Implement account fetching using TinkLink v4+ async/await API
    func fetchAccounts() async throws -> [TinkAccount] {
        // Use TinkLink async/await methods here
        return []
    }
    
    /// TODO: Implement transaction fetching using TinkLink v4+ async/await API
    func fetchTransactions() async throws -> [Transaction] {
        // Use TinkLink async/await methods here
        return []
    }
    
    // MARK: - Keychain Helper
    private func storeToken(_ token: String) {
        KeychainHelper.save(token, service: "com.fingrip.tink", account: tokenKey)
        self.accessToken = token
    }
    
    private func retrieveToken() -> String? {
        if let token = KeychainHelper.read(service: "com.fingrip.tink", account: tokenKey) {
            self.accessToken = token
            return token
        }
        return nil
    }
    
    // Add a method to provide TinkLink.Configuration
    func makeTinkLinkConfiguration() -> TinkLink.Configuration {
        TinkLink.Configuration(
            clientID: TinkConfiguration.clientID,
            redirectURI: TinkConfiguration.redirectURI
        )
    }
}

/// Model representing a Tink account
struct TinkAccount: Codable, Identifiable {
    let id: String
    let name: String
    let type: AccountType
    let balance: Double
    let currencyCode: String
    
    enum AccountType: String, Codable {
        case checking = "CHECKING"
        case savings = "SAVINGS"
        case investment = "INVESTMENT"
        case credit = "CREDIT"
        case loan = "LOAN"
        case other = "OTHER"
    }
}

struct KeychainHelper {
    static func save(_ value: String, service: String, account: String) {
        let data = value.data(using: .utf8) ?? Data()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        SecItemAdd(attributes as CFDictionary, nil)
    }
    static func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }
}

// Add at the top, before the TinkService class
enum TinkAuthenticationState: Equatable {
    case notAuthenticated
    case authenticated(code: String)
    case error(Error)

    static func == (lhs: TinkAuthenticationState, rhs: TinkAuthenticationState) -> Bool {
        switch (lhs, rhs) {
        case (.notAuthenticated, .notAuthenticated):
            return true
        case let (.authenticated(code1), .authenticated(code2)):
            return code1 == code2
        case let (.error(err1), .error(err2)):
            return String(describing: err1) == String(describing: err2)
        default:
            return false
        }
    }
}

// Find the TinkConfiguration struct/class and add this property if missing
// static var testMode: Bool = false 