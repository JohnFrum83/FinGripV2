import SwiftUI

// MARK: - ViewModel
class OnboardingViewModel: ObservableObject {
    @Published var overallScore: Int = 0
    @Published var categoryScores: [FinancialCategory: Int] = [
        .savings: 0,
        .debt: 0,
        .spending: 0,
        .income: 0
    ]
    
    func completeOnboarding() {
        // Save onboarding completion state
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Calculate scores based on user's selections and data
        calculateScores()
    }
    
    private func calculateScores() {
        // Calculate initial scores based on predefined criteria
        categoryScores = [
            .savings: 60,  // Starting with moderate savings score
            .debt: 75,     // Good debt management score
            .spending: 65, // Moderate spending control
            .income: 70    // Good income stability
        ]
        
        // Calculate overall score as weighted average
        overallScore = Int(categoryScores.values.reduce(0.0) { $0 + Double($1) } / Double(categoryScores.count))
    }
}

// MARK: - View
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentStep = 0
    @State private var selectedCurrency = Currency.usd
    @State private var selectedBank: String?
    @State private var selectedGoal: OnboardingGoal?
    @State private var isAnalyzing = false
    @State private var analysisProgress = 0.0
    let onComplete: () -> Void
    
    private let steps = ["welcome", "bank", "goals", "analysis", "score", "quickwin"]
    
    var body: some View {
        VStack {
            switch steps[currentStep] {
            case "welcome":
                welcomeView
            case "bank":
                bankSelectionView
            case "goals":
                goalsView
            case "analysis":
                analysisView
            case "score":
                scoreView
            case "quickwin":
                quickWinView
            default:
                EmptyView()
            }
            
            navigationButtons
        }
        .animation(.easeInOut, value: currentStep)
    }
    
    private var welcomeView: some View {
        VStack(spacing: 20) {
            Text(LocalizationKey.onboardingWelcomeTitle.localized)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(LocalizationKey.onboardingWelcomeSubtitle.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                Text(LocalizationKey.onboardingWelcomeCurrency.localized)
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
            Text(LocalizationKey.onboardingBankTitle.localized)
                .font(.largeTitle)
                .bold()
            
            Text(LocalizationKey.onboardingBankSubtitle.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text(LocalizationKey.onboardingBankDescription.localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                // Handle bank connection
            }) {
                Text(LocalizationKey.buttonConnect.localized)
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
    
    private var goalsView: some View {
        VStack(spacing: 20) {
            Text(LocalizationKey.onboardingGoalsTitle.localized)
                .font(.largeTitle)
                .bold()
            
            Text(LocalizationKey.onboardingGoalsSubtitle.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(OnboardingGoal.allCases) { goal in
                        OnboardingGoalCard(goal: goal, isSelected: selectedGoal == goal) {
                            selectedGoal = goal
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private var analysisView: some View {
        VStack(spacing: 20) {
            Text(LocalizationKey.onboardingAnalysisTitle.localized)
                .font(.largeTitle)
                .bold()
            
            Text(LocalizationKey.onboardingAnalysisProcessing.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                AnalysisItem(text: LocalizationKey.onboardingAnalysisBank.localized, isComplete: analysisProgress >= 0.25)
                AnalysisItem(text: LocalizationKey.onboardingAnalysisTransactions.localized, isComplete: analysisProgress >= 0.5)
                AnalysisItem(text: LocalizationKey.onboardingAnalysisGoals.localized, isComplete: analysisProgress >= 0.75)
                AnalysisItem(text: LocalizationKey.onboardingAnalysisPlan.localized, isComplete: analysisProgress >= 1.0)
            }
            .padding()
        }
        .padding()
        .onAppear {
            startAnalysis()
        }
    }
    
    private var scoreView: some View {
        VStack(spacing: 20) {
            Text(LocalizationKey.onboardingScoreTitle.localized)
                .font(.largeTitle)
                .bold()
            
            Text(LocalizationKey.onboardingScoreReady.localized)
                .font(.title2)
                .foregroundColor(.secondary)
            
            ScoreCircle(score: viewModel.overallScore)
                .frame(width: 200, height: 200)
            
            Text(LocalizationKey.onboardingScoreDescription.localized)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ScoreRow(category: .savings, score: viewModel.categoryScores[.savings] ?? 0)
                ScoreRow(category: .debt, score: viewModel.categoryScores[.debt] ?? 0)
                ScoreRow(category: .spending, score: viewModel.categoryScores[.spending] ?? 0)
                ScoreRow(category: .income, score: viewModel.categoryScores[.income] ?? 0)
            }
            .padding()
        }
        .padding()
    }
    
    private var quickWinView: some View {
        VStack(spacing: 20) {
            Text(LocalizationKey.onboardingQuickWinTitle.localized)
                .font(.largeTitle)
                .bold()
            
            Text(LocalizationKey.onboardingQuickWinSubtitle.localized)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 15) {
                QuickWinItem(text: LocalizationKey.onboardingQuickWinItem1.localized, isComplete: false)
                QuickWinItem(text: LocalizationKey.onboardingQuickWinItem2.localized, isComplete: false)
                QuickWinItem(text: LocalizationKey.onboardingQuickWinItem3.localized, isComplete: false)
            }
            .padding()
        }
        .padding()
    }
    
    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button(action: {
                    currentStep -= 1
                }) {
                    Text(LocalizationKey.buttonBack.localized)
                }
            }
            
            Spacer()
            
            Button(action: {
                if currentStep < steps.count - 1 {
                    currentStep += 1
                } else {
                    viewModel.completeOnboarding()
                    onComplete()
                }
            }) {
                Text(currentStep < steps.count - 1 ? LocalizationKey.buttonNext.localized : LocalizationKey.buttonFinish.localized)
                    .bold()
            }
        }
        .padding()
    }
    
    private func startAnalysis() {
        isAnalyzing = true
        withAnimation(.easeInOut(duration: 4.0)) {
            analysisProgress = 1.0
        }
    }
}

// MARK: - Supporting Views

struct OnboardingGoalCard: View {
    let goal: OnboardingGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey(goal.title))
                        .font(.headline)
                    Text(LocalizedStringKey(goal.description))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AnalysisItem: View {
    let text: String
    let isComplete: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isComplete ? .green : .secondary)
            Text(text)
                .foregroundColor(isComplete ? .primary : .secondary)
        }
    }
}

struct ScoreCircle: View {
    let score: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 15)
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(scoreColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack {
                Text("\(score)")
                    .font(.system(size: 44, weight: .bold))
                Text("/100")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var scoreColor: Color {
        switch score {
        case 0...40: return .red
        case 41...70: return .orange
        default: return .green
        }
    }
}

struct ScoreRow: View {
    let category: FinancialCategory
    let score: Int
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(category.color)
            Text(category.displayName)
            Spacer()
            Text("\(score)")
                .bold()
        }
    }
}

struct QuickWinItem: View {
    let text: String
    let isComplete: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isComplete ? .green : .accentColor)
            Text(text)
        }
    }
}

// MARK: - Supporting Types

enum OnboardingGoal: String, CaseIterable, Identifiable {
    case emergency
    case debt
    case invest
    case budget
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .emergency: return "onboarding.goals.emergency".localized
        case .debt: return "onboarding.goals.debt".localized
        case .invest: return "onboarding.goals.invest".localized
        case .budget: return "onboarding.goals.budget".localized
        }
    }
    
    var description: String {
        switch self {
        case .emergency: return "onboarding.goals.emergency.desc".localized
        case .debt: return "onboarding.goals.debt.desc".localized
        case .invest: return "onboarding.goals.invest.desc".localized
        case .budget: return "onboarding.goals.budget.desc".localized
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onComplete: {})
            .environmentObject(LocalizationManager.shared)
    }
} 