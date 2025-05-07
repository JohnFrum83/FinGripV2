import SwiftUI
import SafariServices
import TinkLink

struct Bank: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// Custom animated counter modifier
struct CountingModifier: AnimatableModifier {
    var value: Double
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(
            Text("\(Int(value))")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.blue)
        )
    }
}

struct SyncBankView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var tinkService = TinkService.shared
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @State private var isPresentingTinkLink = false
    @State private var isConnected = false
    @State private var healthScore = 754
    @State private var animatedScore: Double = 0
    @State private var isAnimating = false
    @State private var fetchedAccounts: [TinkAccount] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if !isConnected {
                Text("Connect Your Bank")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Securely connect your accounts for personalized insights")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding()
                
                VStack(spacing: 16) {
                    Button(action: {
                        Task {
                            do {
                                let result = try await tinkService.authenticate()
                                // Update authState or handle result as needed
                                tinkService.setAuthState(.authenticated(code: "dummy-code")) // Replace with actual code if available
                            } catch {
                                tinkService.setAuthState(.error(error))
                            }
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
                    
                    Button(action: {
                        navigationPath.append("quickWin")
                    }) {
                        Text("Skip for Now")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                        .padding()
                    
                    Text("Bank Connected!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your Financial Health Score")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: animatedScore / 1000)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [
                                        .red,
                                        .orange,
                                        Color(red: 0.7, green: 0.9, blue: 0.3),  // Light green
                                        Color(red: 0.0, green: 0.6, blue: 0.0)   // Dark green
                                    ]),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 2.0), value: animatedScore)
                        
                        VStack(spacing: 4) {
                            Text("\(Int(animatedScore))")
                                .font(.system(size: 64, weight: .bold))
                                .foregroundColor(.blue)
                                .contentTransition(.numericText(value: Double(Int(animatedScore))))
                            Text("out of 1000")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical)
                    
                    Text("Good")
                        .font(.title3)
                        .foregroundColor(.green)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn.delay(2.0), value: isAnimating)
                    
                    Text("Your financial health is above average.\nLet's make it even better!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn.delay(2.0), value: isAnimating)
                    
                    if !fetchedAccounts.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Connected Accounts:")
                                .font(.headline)
                            ForEach(fetchedAccounts) { account in
                                HStack {
                                    Text(account.name)
                                    Spacer()
                                    Text("\(account.balance, specifier: "%.2f") \(account.currencyCode)")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        navigationPath.append("scoreDetails")
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn.delay(2.2), value: isAnimating)
                }
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: isConnected)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onChange(of: tinkService.authState) { newState in
            if case .authenticated = newState {
                isConnected = true
                // Optionally fetch accounts/transactions here
            }
        }
    }
}

#Preview {
    NavigationStack {
        SyncBankView(navigationPath: .constant(NavigationPath()))
    }
} 