import SwiftUI

struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    @State private var name = ""
    @State private var amount = ""
    @State private var billingCycle = Subscription.BillingCycle.monthly
    @State private var category = Subscription.SubscriptionCategory.streaming
    @State private var startDate = Date()
    @State private var notes = ""
    
    private var isFormValid: Bool {
        !name.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Information
                Section(header: Text("Subscription Details")) {
                    TextField("Name", text: $name)
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(Subscription.BillingCycle.allCases, id: \.self) { cycle in
                            Text(cycle.rawValue.capitalized)
                                .tag(cycle)
                        }
                    }
                }
                
                // Category
                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
                        ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                }
                
                // Additional Details
                Section(header: Text("Additional Details")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                // Summary
                if let amount = Double(amount) {
                    Section(header: Text("Summary")) {
                        HStack {
                            Text("Monthly Cost")
                            Spacer()
                            Text(monthlyAmount(amount).currencyFormatted())
                                .bold()
                        }
                        
                        HStack {
                            Text("Annual Cost")
                            Spacer()
                            Text((monthlyAmount(amount) * 12).currencyFormatted())
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSubscription()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func monthlyAmount(_ amount: Double) -> Double {
        switch billingCycle {
        case .monthly:
            return amount
        case .yearly:
            return amount / 12
        case .quarterly:
            return amount / 3
        }
    }
    
    private func addSubscription() {
        guard let amount = Double(amount) else { return }
        
        let subscription = Subscription(
            name: name,
            category: category,
            monthlyAmount: monthlyAmount(amount),
            billingCycle: billingCycle,
            isActive: true,
            lastBillingDate: startDate,
            nextBillingDate: Date(),
            notes: notes,
            lastUsed: Date()
        )
        
        contentViewModel.subscriptions.append(subscription)
        dismiss()
    }
}

#Preview {
    AddSubscriptionView()
        .environmentObject(ContentViewModel())
} 