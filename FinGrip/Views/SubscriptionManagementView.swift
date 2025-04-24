import SwiftUI
import Charts
import PDFKit

struct SubscriptionManagementView: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    @State private var showingAddSubscription = false
    @State private var selectedSubscription: Subscription?
    @State private var showingSubscriptionDetails = false
    @State private var searchText = ""
    @State private var showingPDFPreview = false
    @State private var reportPDFData: Data?
    @State private var selectedCategory: Subscription.SubscriptionCategory?
    
    private var filteredSubscriptions: [Subscription] {
        var subscriptions = viewModel.subscriptions
        
        if !searchText.isEmpty {
            subscriptions = subscriptions.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            subscriptions = subscriptions.filter { $0.category == category }
        }
        
        return subscriptions
    }
    
    var body: some View {
        NavigationView {
            List {
                subscriptionSummaryView
                subscriptionChartView
                subscriptionListView
                optimizationSuggestionsView
            }
            .searchable(text: $searchText, prompt: "Search subscriptions")
            .navigationTitle(NSLocalizedString("subscription.management.title", comment: "Subscription Management"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSubscription = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSubscription) {
                AddSubscriptionView()
            }
            .sheet(isPresented: $showingSubscriptionDetails) {
                if let subscription = selectedSubscription {
                    SubscriptionDetailView(subscription: subscription)
                }
            }
            .sheet(isPresented: $showingPDFPreview) {
                pdfPreviewSheet
            }
        }
    }
    
    private var subscriptionSummaryView: some View {
        SubscriptionSummarySection(
            subscriptions: filteredSubscriptions,
            selectedCategory: $selectedCategory,
            onGenerateReport: generateReport
        )
    }
    
    private var subscriptionChartView: some View {
        SubscriptionChartSection(subscriptions: filteredSubscriptions)
    }
    
    private var subscriptionListView: some View {
        SubscriptionListSection(
            subscriptions: filteredSubscriptions,
            onSubscriptionSelected: { subscription in
                selectedSubscription = subscription
                showingSubscriptionDetails = true
            }
        )
    }
    
    private var optimizationSuggestionsView: some View {
        Group {
            if !optimizationSuggestions.isEmpty {
                OptimizationSuggestionsSection(suggestions: optimizationSuggestions)
            }
        }
    }
    
    private var pdfPreviewSheet: some View {
        Group {
            if let pdfData = reportPDFData {
                NavigationView {
                    PDFKitView(data: pdfData)
                        .navigationTitle("Subscription Report")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                ShareLink(item: pdfData, preview: SharePreview("Subscription Report", image: Image(systemName: "doc.text.fill")))
                            }
                        }
                }
            }
        }
    }
    
    private func generateReport() {
        reportPDFData = PDFCreator.createSubscriptionReport(subscriptions: filteredSubscriptions)
        showingPDFPreview = true
    }
    
    private var optimizationSuggestions: [OptimizationSuggestion] {
        var suggestions: [OptimizationSuggestion] = []
        
        // Check for unused subscriptions
        let unusedSubscriptions = viewModel.subscriptions
            .filter { $0.lastUsed == nil || daysSinceLastUsed($0) > 30 }
        
        if !unusedSubscriptions.isEmpty {
            suggestions.append(OptimizationSuggestion(
                id: UUID(),
                title: "Unused Subscriptions",
                description: "You haven't used these services in over 30 days",
                impact: unusedSubscriptions.reduce(0) { $0 + $1.monthlyAmount },
                type: .cancel,
                affectedSubscriptions: unusedSubscriptions
            ))
        }
        
        // Check for duplicate categories
        let categoryGroups = Dictionary(grouping: viewModel.subscriptions) { $0.category }
        for (category, subscriptions) in categoryGroups {
            if subscriptions.count > 1 {
                suggestions.append(OptimizationSuggestion(
                    id: UUID(),
                    title: "Multiple \(category.rawValue.capitalized) Subscriptions",
                    description: "Consider consolidating these services",
                    impact: subscriptions.reduce(0) { $0 + $1.monthlyAmount },
                    type: .consolidate,
                    affectedSubscriptions: subscriptions
                ))
            }
        }
        
        return suggestions
    }
    
    private func daysSinceLastUsed(_ subscription: Subscription) -> Int {
        guard let lastUsed = subscription.lastUsed else { return Int.max }
        return Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
    }
}

// MARK: - Summary Section
struct SubscriptionSummarySection: View {
    let subscriptions: [Subscription]
    @Binding var selectedCategory: Subscription.SubscriptionCategory?
    let onGenerateReport: () -> Void
    
    private var totalMonthlySpend: Double {
        subscriptions.reduce(0) { $0 + $1.monthlyAmount }
    }
    
    private var potentialSavings: Double {
        subscriptions
            .filter { $0.lastUsed == nil || daysSinceLastUsed($0) > 30 }
            .reduce(0) { $0 + $1.monthlyAmount }
    }
    
    var body: some View {
        Section {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Monthly Spend")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(totalMonthlySpend.currencyFormatted())
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                    Button(action: onGenerateReport) {
                        VStack {
                            Image(systemName: "doc.text.fill")
                                .font(.title2)
                            Text("Export")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                if potentialSavings > 0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Potential savings of \(potentialSavings.currencyFormatted())/month")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
                
                CategoryFilterView(selectedCategory: $selectedCategory)
            }
        }
    }
    
    private func daysSinceLastUsed(_ subscription: Subscription) -> Int {
        guard let lastUsed = subscription.lastUsed else { return Int.max }
        return Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
    }
}

// MARK: - Chart Section
struct SubscriptionChartSection: View {
    let subscriptions: [Subscription]
    
    var body: some View {
        Section {
            Chart(categoryData, id: \.0) { category, amount in
                SectorMark(
                    angle: .value("Amount", amount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(3)
                .foregroundStyle(by: .value("Category", category.rawValue.capitalized))
            }
            .frame(height: 200)
        }
    }
    
    private var categoryData: [(Subscription.SubscriptionCategory, Double)] {
        Dictionary(grouping: subscriptions) { $0.category }
            .map { (category, subscriptions) in
                (category, subscriptions.reduce(0) { $0 + $1.monthlyAmount })
            }
            .sorted { $0.1 > $1.1 }
    }
}

// MARK: - List Section
struct SubscriptionListSection: View {
    let subscriptions: [Subscription]
    let onSubscriptionSelected: (Subscription) -> Void
    @EnvironmentObject private var contentViewModel: ContentViewModel
    
    var body: some View {
        Section(header: Text("Active Subscriptions")) {
            ForEach(subscriptions) { subscription in
                SubscriptionRow(
                    subscription: subscription,
                    onDelete: {
                        contentViewModel.deleteSubscription(subscription)
                    }
                )
                .onTapGesture {
                    onSubscriptionSelected(subscription)
                }
            }
        }
    }
}

// MARK: - Optimization Suggestions Section
struct OptimizationSuggestionsSection: View {
    let suggestions: [OptimizationSuggestion]
    
    var body: some View {
        Section(header: Text("Suggestions")) {
            ForEach(suggestions) { suggestion in
                OptimizationSuggestionRow(suggestion: suggestion)
            }
        }
    }
}

// MARK: - Category Filter View
struct CategoryFilterView: View {
    @Binding var selectedCategory: Subscription.SubscriptionCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryFilterButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                ForEach(Subscription.SubscriptionCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue.capitalized,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Supporting Types
struct OptimizationSuggestion: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let impact: Double
    let type: SuggestionType
    let affectedSubscriptions: [Subscription]
    
    enum SuggestionType {
        case cancel
        case consolidate
        case switchToAnnual
        
        var icon: String {
            switch self {
            case .cancel: return "xmark.circle"
            case .consolidate: return "arrow.triangle.merge"
            case .switchToAnnual: return "arrow.2.squarepath"
            }
        }
        
        var color: Color {
            switch self {
            case .cancel: return .red
            case .consolidate: return .orange
            case .switchToAnnual: return .blue
            }
        }
    }
}

struct OptimizationSuggestionRow: View {
    let suggestion: OptimizationSuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: suggestion.type.icon)
                    .foregroundColor(suggestion.type.color)
                Text(suggestion.title)
                    .font(.headline)
            }
            
            Text(suggestion.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Potential savings: \(suggestion.impact.currencyFormatted())/year")
                .font(.caption)
                .foregroundColor(.green)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(data: data)
    }
}

#Preview {
    SubscriptionManagementView()
        .environmentObject(ContentViewModel())
} 