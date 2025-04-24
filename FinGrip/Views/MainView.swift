import SwiftUI
import Foundation

/// The main navigation container for the FinGrip application.
/// This view serves as the root view of the app and manages the navigation stack
/// for the entire application. It handles the flow between different views:
/// - Splash screen on app launch
/// - Welcome screen for new users
/// - Onboarding flow for bank connection and setup
/// - Main app interface for existing users
///
/// The view uses a NavigationStack to manage the navigation state and provides
/// a centralized location for handling navigation-related logic.
struct MainView: View {
    /// The current navigation path for the app
    @State private var path = NavigationPath()
    
    /// The current view to display in the navigation stack
    @State private var currentView: AppView = .splash
    
    /// Controls the animation state of the splash screen
    @State private var isSplashAnimating = false
    
    /// Controls the visibility of the welcome screen
    @State private var isWelcomeShown = true
    
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationStack(path: $path) {
            switch currentView {
            case .splash:
                SplashView(isAnimating: $isSplashAnimating)
                    .onAppear {
                        // Transition to welcome view after splash screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                currentView = .welcome
                            }
                        }
                    }
            case .welcome:
                WelcomeView(isWelcomeShown: $isWelcomeShown)
                    .onChange(of: isWelcomeShown) { _, newValue in
                        if !newValue {
                            withAnimation {
                                currentView = .onboarding
                            }
                        }
                    }
            case .onboarding:
                OnboardingView(onComplete: {
                    withAnimation {
                        currentView = .main
                    }
                })
            case .main:
                DashboardTabView()
            }
        }
    }
}

/// Represents the different views in the FinGrip application
enum AppView: String, Codable, Hashable {
    /// The initial splash screen shown when the app launches
    case splash
    /// The welcome screen shown to new users
    case welcome
    /// The onboarding flow for setting up the app
    case onboarding
    /// The main dashboard view shown to existing users
    case main
}

/// Preview provider for MainView
#Preview {
    MainView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
} 