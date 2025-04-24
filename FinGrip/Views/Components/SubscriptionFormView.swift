import SwiftUI

struct SubscriptionFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ContentViewModel
    @State private var name = ""
    @State private var category: Subscription.SubscriptionCategory = .streaming
    @State private var amount = ""
    @State private var billingCycle: Subscription.BillingCycle = .monthly
    @State private var notes = ""
    
    private var amountLabel: String {
        switch billingCycle {
        case .monthly: return "Monthly Amount"
        case .quarterly: return "Quarterly Amount"
        case .yearly: return "Yearly Amount"
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField(amountLabel, text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $category) {
                    ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                        Label(category.rawValue.capitalized, systemImage: category.icon)
                            .tag(category)
                    }
                }
                
                Picker("Billing Cycle", selection: $billingCycle) {
                    ForEach(Subscription.BillingCycle.allCases, id: \.self) { cycle in
                        Text(cycle.rawValue.capitalized)
                            .tag(cycle)
                    }
                }
                
                TextField("Notes", text: $notes)
            }
        }
        .navigationTitle("Add Subscription")
        .navigationBarItems(
            leading: Button("Cancel") {
                dismiss()
            },
            trailing: Button("Save") {
                if let amountValue = Double(amount) {
                    let subscription = Subscription(
                        name: name,
                        category: category,
                        monthlyAmount: amountValue / Double(billingCycle.multiplier), // Convert to monthly
                        billingCycle: billingCycle,
                        notes: notes.isEmpty ? nil : notes
                    )
                    viewModel.addSubscription(subscription)
                    dismiss()
                }
            }
            .disabled(name.isEmpty || amount.isEmpty)
        )
    }
} 