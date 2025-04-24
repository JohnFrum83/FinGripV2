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
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath
    @State private var selectedTasks: Set<String> = []
    
    private let tasks: [(id: String, title: String, description: String, points: Int, icon: String)] = [
        ("track_expenses", NSLocalizedString("quickwin.track_expenses.title", comment: "Track daily expenses title"),
         NSLocalizedString("quickwin.track_expenses.description", comment: "Track daily expenses description"), 75, "list.clipboard"),
        ("auto_savings", NSLocalizedString("quickwin.auto_savings.title", comment: "Set up auto-savings title"),
         NSLocalizedString("quickwin.auto_savings.description", comment: "Set up auto-savings description"), 80, "clock.arrow.circlepath"),
        ("credit_report", NSLocalizedString("quickwin.credit_report.title", comment: "Review credit report title"),
         NSLocalizedString("quickwin.credit_report.description", comment: "Review credit report description"), 60, "doc.text.magnifyingglass"),
        ("small_debt", NSLocalizedString("quickwin.small_debt.title", comment: "Pay off smaller debt title"),
         NSLocalizedString("quickwin.small_debt.description", comment: "Pay off smaller debt description"), 90, "creditcard"),
        ("emergency_fund", NSLocalizedString("quickwin.emergency_fund.title", comment: "Create emergency fund title"),
         NSLocalizedString("quickwin.emergency_fund.description", comment: "Create emergency fund description"), 100, "umbrella"),
        ("subscription_costs", NSLocalizedString("quickwin.subscription_costs.title", comment: "Cut subscription costs title"),
         NSLocalizedString("quickwin.subscription_costs.description", comment: "Cut subscription costs description"), 50, "scissors")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(NSLocalizedString("quickwin.subtitle", comment: "Quick wins subtitle"))
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(tasks, id: \.id) { task in
                            QuickWinTaskRow(
                                title: task.title,
                                description: task.description,
                                points: task.points,
                                icon: task.icon,
                                isSelected: selectedTasks.contains(task.id)
                            ) {
                                if selectedTasks.contains(task.id) {
                                    selectedTasks.remove(task.id)
                                } else {
                                    selectedTasks.insert(task.id)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Button(action: startJourney) {
                    Text(NSLocalizedString("quickwin.start_journey", comment: "Start journey button"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle(NSLocalizedString("quickwin.title", comment: "Quick wins title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("common.done", comment: "Done button")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func startJourney() {
        // Handle starting the journey with selected tasks
        if !selectedTasks.isEmpty {
            // Navigate to the first task or show task details
            // You can customize this based on your navigation requirements
            dismiss()
        }
    }
}

struct QuickWinTaskRow: View {
    let title: String
    let description: String
    let points: Int
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .accentColor : .gray)
                    
                    Text("\(points) \(NSLocalizedString("common.points", comment: "Points"))")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuickWinView(navigationPath: .constant(NavigationPath()))
} 