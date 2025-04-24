import SwiftUI

struct WelcomeView: View {
    @Binding var isWelcomeShown: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Group {
                if let appIcon = UIImage(named: "AppIcon") {
                    Image(uiImage: appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "eurosign.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 8, y: 4)
            
            Text(LocalizationKey.onboardingWelcomeTitle.localized)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(LocalizationKey.onboardingWelcomeSubtitle.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                isWelcomeShown = false
            }) {
                Text(LocalizationKey.buttonGetStarted.localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
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