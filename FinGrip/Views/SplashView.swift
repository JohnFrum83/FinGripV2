import SwiftUI

/// SplashView displays the app's initial loading screen with animation
struct SplashView: View {
    @Binding var isAnimating: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "eurosign.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text(LocalizationKey.appName.localized)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
                    .opacity(opacity)
                
                // Loading indicator
                ProgressView()
                    .scaleEffect(1.5)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            isAnimating = true
        }
    }
}

#Preview {
    SplashView(isAnimating: .constant(true))
        .environmentObject(LocalizationManager.shared)
} 