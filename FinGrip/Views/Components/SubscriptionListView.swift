import SwiftUI

struct SubscriptionListView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    var body: some View {
        List {
            ForEach(contentViewModel.subscriptions) { subscription in
                SubscriptionRow(subscription: subscription) {
                    if let index = contentViewModel.subscriptions.firstIndex(where: { $0.id == subscription.id }) {
                        contentViewModel.subscriptions.remove(at: index)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SubscriptionListView()
        .environmentObject(ContentViewModel())
} 