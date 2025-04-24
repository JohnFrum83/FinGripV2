import SwiftUI

/// SplashView displays the app's initial loading screen with animation
struct SplashView: View {
    @Binding var isAnimating: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = -30
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Using AppIcon as logo with fallback
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
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .shadow(radius: 10, y: 5)
                
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
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
            }
            withAnimation(.easeOut(duration: 0.8)) {
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