import SwiftUI

struct OnboardingView: View {
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
            Text("onboarding.bank.title".localized)
                .font(.largeTitle)
                .bold()
            
            Text("onboarding.bank.subtitle".localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("onboarding.bank.description".localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                // Handle bank connection
            }) {
                Text("button.connect".localized)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(LocalizationManager.shared)
    }
} 