import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var selectedCurrency: Currency = .usd
    @EnvironmentObject private var localizationManager: LocalizationManager

    var body: some View {
        welcomeView
        bankSelectionView
    }

    private var welcomeView: some View {
        VStack(spacing: 20) {
            Text("onboarding.welcome.title".localized)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("onboarding.welcome.subtitle".localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                Text("onboarding.welcome.currency".localized)
                    .font(.headline)
                
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.symbol)
                            .tag(currency)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.top, 30)
        }
        .padding()
    }
    
    private var bankSelectionView: some View {
        VStack(spacing: 20) {
            Text("Connect Your Bank")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Link your bank account to get started")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Image(systemName: "banknote.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding()
            
            Text("We'll help you connect your bank securely to track your finances")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: onComplete) {
                Text("Connect Bank")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onComplete: {})
            .environmentObject(LocalizationManager.shared)
    }
} 