import SwiftUI

struct SubscriptionDetailView: View {
    let subscription: Subscription
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var lastUsedText: String {
        guard let lastUsed = subscription.lastUsed else { return "Never used" }
        let days = Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
        return "\(days) days ago"
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Details") {
                    DetailRow(title: "Name", value: subscription.name)
                    DetailRow(title: "Category", value: subscription.category.rawValue.capitalized)
                    DetailRow(title: "Monthly Cost", value: subscription.actualMonthlyAmount.currencyFormatted())
                    DetailRow(title: "Billing Cycle", value: subscription.billingCycle.rawValue.capitalized)
                    DetailRow(title: "Last Used", value: lastUsedText)
                }
                
                if let notes = subscription.notes, !notes.isEmpty {
                    Section("Notes") {
                        Text(notes)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Subscription", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Subscription Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingEditSheet) {
                EditSubscriptionView(contentViewModel: contentViewModel, subscription: subscription)
            }
            .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    contentViewModel.deleteSubscription(subscription)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this subscription? This action cannot be undone.")
            }
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
} 