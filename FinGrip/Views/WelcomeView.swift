import SwiftUI
import SafariServices

struct WelcomeView: View {
    @Binding var isWelcomeShown: Bool
    @StateObject private var tinkService = TinkService.shared
    @State private var selectedCurrency: Currency = .eur
    @State private var isShowingSafari = false
    
    enum Currency: String, CaseIterable {
        case usd = "$"
        case eur = "€"
        case pln = "zł"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to FinGrip")
                .font(.largeTitle)
                .bold()
                .padding(.top, 60)
            
            Text("Take control of your finances with smart tracking and insights")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    Text("Choose Your Currency")
                        .font(.title2)
                        .bold()
                    
                    HStack(spacing: 0) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Button(action: {
                                selectedCurrency = currency
                            }) {
                                Text(currency.rawValue)
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedCurrency == currency ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedCurrency == currency ? .white : .primary)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(spacing: 16) {
                    Text("Connect Your Bank")
                        .font(.title2)
                        .bold()
                    
                    Text("Link your bank account to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "banknote")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    
                    Text("We'll help you connect your bank securely to track your finances")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        if let url = tinkService.getAuthorizationUrl() {
                            isShowingSafari = true
                        }
                    }) {
                        Text("Connect Bank")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                isWelcomeShown = false
            }) {
                Text("Skip for Now")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $isShowingSafari) {
            if let url = tinkService.getAuthorizationUrl() {
                SafariView(url: url)
            }
        }
        .onOpenURL { url in
            Task {
                await tinkService.handleCallback(url)
                if case .authenticated = tinkService.authState {
                    isWelcomeShown = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView(isWelcomeShown: .constant(true))
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
} 