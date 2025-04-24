import SwiftUI

struct EditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var contentViewModel: ContentViewModel
    let subscription: Subscription
    
    @State private var name: String
    @State private var category: Subscription.SubscriptionCategory
    @State private var amount: Double
    @State private var billingCycle: Subscription.BillingCycle
    @State private var isActive: Bool
    @State private var notes: String
    
    private var amountLabel: String {
        switch billingCycle {
        case .monthly: return "Monthly Amount"
        case .quarterly: return "Quarterly Amount"
        case .yearly: return "Yearly Amount"
        }
    }
    
    init(contentViewModel: ContentViewModel, subscription: Subscription) {
        self.contentViewModel = contentViewModel
        self.subscription = subscription
        _name = State(initialValue: subscription.name)
        _category = State(initialValue: subscription.category)
        _amount = State(initialValue: subscription.monthlyAmount * Double(subscription.billingCycle.multiplier))
        _billingCycle = State(initialValue: subscription.billingCycle)
        _isActive = State(initialValue: subscription.isActive)
        _notes = State(initialValue: subscription.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                }
                
                Section {
                    TextField(amountLabel, value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(Subscription.BillingCycle.allCases, id: \.self) { cycle in
                            Text(cycle.rawValue.capitalized)
                                .tag(cycle)
                        }
                    }
                    Toggle("Active", isOn: $isActive)
                }
                
                Section {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Edit Subscription")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let updatedSubscription = Subscription(
                        id: subscription.id,
                        name: name,
                        category: category,
                        monthlyAmount: amount / Double(billingCycle.multiplier),
                        billingCycle: billingCycle,
                        isActive: isActive,
                        notes: notes.isEmpty ? nil : notes
                    )
                    contentViewModel.updateSubscription(updatedSubscription)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    EditSubscriptionView(
        contentViewModel: ContentViewModel(),
        subscription: Subscription.sampleSubscriptions[0]
    )
} 