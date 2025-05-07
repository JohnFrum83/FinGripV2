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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                currentView = .intro
                            }
                        }
                    }
            case .intro:
                IntroView(onContinue: {
                    withAnimation { currentView = .register }
                })
            case .register:
                RegisterView(onRegister: {
                    withAnimation { currentView = .connectBank }
                })
            case .connectBank:
                WelcomeView(isWelcomeShown: .constant(true), onBankConnected: {
                    withAnimation { currentView = .scoreReview }
                })
            case .scoreReview:
                ScoreReviewView(onContinue: {
                    withAnimation { currentView = .main }
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
    /// The intro view before registering
    case intro
    /// The register view for new users
    case register
    /// The connect bank view for new users
    case connectBank
    /// The score review view after connecting bank
    case scoreReview
}

/// Preview provider for MainView
#Preview {
    MainView()
        .environmentObject(ContentViewModel())
        .environmentObject(LocalizationManager.shared)
}

// --- Add stubs for new onboarding screens ---

struct IntroView: View {
    var onContinue: () -> Void
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Fix your finance")
                .font(.largeTitle)
                .bold()
            Text("Your personal financial AI assistant. Start your journey now!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
            Button("Start Journey", action: onContinue)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

struct RegisterView: View {
    var onRegister: () -> Void
    @State private var name = ""
    @State private var email = ""
    @State private var agreed = false
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Register")
                .font(.largeTitle)
                .bold()
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Toggle("I agree to the terms and conditions", isOn: $agreed)
                .padding(.horizontal)
            Button("Register", action: onRegister)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(agreed ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
                .disabled(!agreed || name.isEmpty || email.isEmpty)
            Spacer()
        }
    }
}

struct ScoreReviewView: View {
    var onContinue: () -> Void
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Your Financial Score")
                .font(.largeTitle)
                .bold()
            // Placeholder for animated score
            Image(systemName: "chart.pie.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
            Text("Congratulations! Your financial journey starts now.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
            Button("Continue", action: onContinue)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
} 