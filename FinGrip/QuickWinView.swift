import SwiftUI

struct QuickWin: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let points: Int
    let icon: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct QuickWinView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedWins: Set<QuickWin> = []
    
    let quickWins = [
        QuickWin(title: "Create Emergency Fund", description: "Start saving for unexpected expenses", points: 100, icon: "umbrella.fill"),
        QuickWin(title: "Cut Subscription Costs", description: "Review and cancel unused subscriptions", points: 50, icon: "scissors"),
        QuickWin(title: "Track Daily Expenses", description: "Record all expenses for one week", points: 75, icon: "list.bullet.clipboard"),
        QuickWin(title: "Set Up Auto-Savings", description: "Automate your savings with scheduled transfers", points: 80, icon: "clock.arrow.circlepath"),
        QuickWin(title: "Review Credit Report", description: "Check your credit score and report", points: 60, icon: "doc.text.magnifyingglass"),
        QuickWin(title: "Pay Off Smaller Debt", description: "Focus on paying off your smallest debt first", points: 90, icon: "creditcard.fill")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Wins")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            Text("Complete these tasks to improve your finances")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(quickWins) { win in
                        QuickWinCard(quickWin: win, isSelected: selectedWins.contains(win))
                            .onTapGesture {
                                if selectedWins.contains(win) {
                                    selectedWins.remove(win)
                                } else {
                                    selectedWins.insert(win)
                                }
                            }
                    }
                }
                .padding()
            }
            
            Button(action: {
                navigationPath.append("dashboard")
            }) {
                Text("Start My Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedWins.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedWins.isEmpty)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuickWinCard: View {
    let quickWin: QuickWin
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: quickWin.icon)
                .font(.title)
                .foregroundColor(isSelected ? .white : .blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(quickWin.title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(quickWin.description)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                
                Text("\(quickWin.points) points")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .blue)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .white : .gray)
                .font(.title2)
        }
        .padding()
        .background(isSelected ? Color.blue : Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    NavigationStack {
        QuickWinView(navigationPath: .constant(NavigationPath()))
    }
} 