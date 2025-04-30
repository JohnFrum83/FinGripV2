import Foundation
import TinkLink

/// Configuration for Tink API integration
struct TinkConfiguration {
    /// The client identifier obtained from Tink Console
    static let clientID = "1a69b73eae894864ad0dd8d14adea1da"
    
    /// The redirect URI registered in Tink Console
    static let redirectURI = "fingrip://callback"
    
    /// The market(s) to enable for the user
    static let market = Market(code: "NL") // Dutch market
    
    /// The locale for the user interface
    static let locale = "nl_NL"
    
    /// Test mode flag
    static let isTestMode = false
    
    /// Get the TinkLink configuration
    static var tinkLinkConfig: Configuration {
        Configuration(
            clientID: clientID,
            redirectURI: redirectURI,
            baseDomain: .eu
        )
    }
    
    /// Get the scopes array for authorization
    static var scopesList: [String] {
        [
            "authorization:read",
            "user:read",
            "credentials:read",
            "credentials:write",
            "credentials:refresh",
            "accounts:read",
            "transactions:read",
            "transactions:categorize",
            "transfer:read",
            "transfer:execute",
            "statistics:read"
        ]
    }
    
    /// Get the refreshable items array
    static var refreshableItemsList: [String] {
        [
            "ACCOUNTS",
            "TRANSACTIONS",
            "CHECKING_ACCOUNTS",
            "CHECKING_TRANSACTIONS",
            "SAVING_ACCOUNTS",
            "SAVING_TRANSACTIONS",
            "CREDITCARD_ACCOUNTS",
            "CREDITCARD_TRANSACTIONS",
            "INVESTMENT_ACCOUNTS",
            "INVESTMENT_TRANSACTIONS",
            "LOAN_ACCOUNTS",
            "LOAN_TRANSACTIONS",
            "TRANSFER_DESTINATIONS"
        ]
    }
}

/// Represents the authentication state for Tink
enum TinkAuthState {
    case notAuthenticated
    case authenticating
    case authenticated(code: String)
    case error(Error)
}

/// Custom error types for Tink operations
enum TinkError: Error {
    case invalidConfiguration
    case authenticationFailed
    case invalidResponse
    case networkError(Error)
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidConfiguration:
            return "Invalid Tink configuration"
        case .authenticationFailed:
            return "Failed to authenticate with Tink"
        case .invalidResponse:
            return "Invalid response from Tink API"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
} 