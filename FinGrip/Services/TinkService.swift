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
    
    private var configuration: Configuration
    
    private init() {
        self.configuration = TinkConfiguration.tinkLinkConfig
    }
    
    func initializeTink() {
        // Initialize with base configuration
        configuration = TinkConfiguration.tinkLinkConfig
        
        // Set additional configuration options
        configuration.locale = TinkConfiguration.locale
        configuration.market = TinkConfiguration.market
        configuration.isTest = TinkConfiguration.isTestMode
    }
    
    /// Generates the authorization URL for Tink Link
    func getAuthorizationUrl() throws -> URL {
        let tinkLinkConfig = TinkLinkConfiguration(
            clientId: configuration.clientId,
            redirectUri: configuration.redirectUri,
            baseDomain: configuration.baseDomain
        )
        
        return try TinkLink.accountAggregation.addCredentials(
            configuration: tinkLinkConfig,
            market: configuration.market,
            authorizationCode: nil,
            locale: configuration.locale,
            scope: [.transactions(.read), .accounts(.read)],
            sessionId: UUID().uuidString,
            inputUsername: nil,
            inputProvider: nil
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let code):
                    self?.authState = .authenticated(code: code)
                case .failure(let error):
                    self?.authState = .error(error)
                }
            }
        }
    }
    
    /// Handles the callback from Tink authentication
    /// - Parameter url: The callback URL containing the authorization code
    func handleCallback(_ url: URL) throws {
        guard url.scheme == "fingrip" else {
            throw TinkError.invalidConfiguration("Invalid URL scheme")
        }
        
        let tinkLinkConfig = TinkLinkConfiguration(
            clientId: configuration.clientId,
            redirectUri: configuration.redirectUri,
            baseDomain: configuration.baseDomain
        )
        
        try TinkLink.handleCallback(configuration: tinkLinkConfig, url: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let code):
                    self?.authState = .authenticated(code: code)
                case .failure(let error):
                    self?.authState = .error(error)
                }
            }
        }
    }
    
    /// Securely store/retrieve tokens (placeholder for Keychain)
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
    
    /// Modularized token exchange with error logging
    func exchangeCodeForTokenModular(_ code: String) async -> Result<String, Error> {
        do {
            let token = try await TinkLink.exchangeAuthorizationCode(code)
            storeToken(token)
            return .success(token)
        } catch {
            logger.error("Token exchange failed: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    /// Fetches user accounts from Tink
    func fetchAccounts() async throws -> [TinkAccount] {
        guard let accessToken = accessToken else {
            throw TinkError.authenticationFailed
        }
        
        let client = TinkLinkClient(accessToken: accessToken)
        return try await client.fetchAccounts()
    }
    
    /// Fetches user transactions from Tink
    func fetchTransactions() async throws -> [Transaction] {
        guard let accessToken = accessToken else {
            throw TinkError.authenticationFailed
        }
        
        let client = TinkLinkClient(accessToken: accessToken)
        let tinkTransactions = try await client.fetchTransactions()
        
        return tinkTransactions.map { tinkTx in
            Transaction(
                date: tinkTx.date,
                amount: tinkTx.amount.value,
                type: tinkTx.amount.value >= 0 ? .income : .expense,
                category: .spending, // Map to your categories as needed
                description: tinkTx.description,
                merchant: tinkTx.merchantName,
                location: nil,
                isRecurring: false,
                tags: []
            )
        }
    }
    
    func fetchUserData(accessToken: String) async throws -> [String: Any] {
        // Initialize Tink client with access token
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        guard let url = URL(string: "https://api.tink.com/api/v1/user") else {
            throw TinkError.invalidConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TinkError.invalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw TinkError.invalidResponse
        }
        
        return json
    }
    
    func fetchTransactions(accessToken: String) async throws -> [String: Any] {
        let headers = ["Authorization": "Bearer \(accessToken)"]
        
        guard let url = URL(string: "https://api.tink.com/data/v2/transactions") else {
            throw TinkError.invalidConfiguration
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TinkError.invalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw TinkError.invalidResponse
        }
        
        return json
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