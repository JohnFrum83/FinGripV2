import SwiftUI
import Charts

/// View for displaying financial analytics and insights.
/// This view provides detailed analysis of the user's financial data, including:
/// - Spending patterns and trends
/// - Category-wise expense breakdown
/// - Income vs. expense comparisons
/// - Financial health indicators
/// - Custom date range analysis
struct AnalyticsView: View {
    /// Access to the shared view model
    @EnvironmentObject private var viewModel: ContentViewModel
    
    /// Currently selected time period for analysis
    @State private var selectedPeriod = 1 // 0: Week, 1: Month, 2: Year
    
    /// Currently selected chart type
    @State private var selectedChart = 0 // 0: Overview, 1: Categories, 2: Trends
    
    /// Sample analytics data for development and preview
    private let categoryData = [
        ("Food", 450.0),
        ("Transport", 200.0),
        ("Housing", 1200.0),
        ("Entertainment", 150.0),
        ("Utilities", 300.0)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time period selector
                    periodPicker
                    
                    // Financial summary cards
                    summarySection
                    
                    // Chart type selector
                    chartTypePicker
                    
                    // Selected chart view
                    chartSection
                    
                    // Category breakdown
                    categorySection
                }
                .padding()
            }
            .navigationTitle("analytics.title".localized)
        }
    }
    
    /// Time period selection control
    private var periodPicker: some View {
        Picker("", selection: $selectedPeriod) {
            Text("analytics.period.week".localized)
                .tag(0)
            Text("analytics.period.month".localized)
                .tag(1)
            Text("analytics.period.year".localized)
                .tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    /// Financial summary cards section
    private var summarySection: some View {
        VStack(spacing: 15) {
            // Net savings card
            summaryCard(
                title: "analytics.summary.savings".localized,
                value: viewModel.totalSaved.currencyFormatted(),
                trend: "+12.5%",
                isPositive: true
            )
            
            // Spending trend card
            summaryCard(
                title: "analytics.summary.spending".localized,
                value: String(format: "%.2f", viewModel.transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }),
                trend: "-5.2%",
                isPositive: false
            )
        }
    }
    
    /// Individual summary card
    private func summaryCard(title: String, value: String, trend: String, isPositive: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2.bold())
            }
            
            Spacer()
            
            Text(trend)
                .font(.headline)
                .foregroundColor(isPositive ? .green : .red)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    /// Chart type selection control
    private var chartTypePicker: some View {
        Picker("", selection: $selectedChart) {
            Text("analytics.chart.overview".localized)
                .tag(0)
            Text("analytics.chart.categories".localized)
                .tag(1)
            Text("analytics.chart.trends".localized)
                .tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    /// Chart display section
    private var chartSection: some View {
        VStack {
            // Placeholder for actual charts
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    Text("analytics.chart.placeholder".localized)
                        .foregroundColor(.blue)
                )
        }
        .padding(.vertical)
    }
    
    /// Category breakdown section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("analytics.categories.title".localized)
                .font(.headline)
            
            ForEach(categoryData, id: \.0) { category, amount in
                HStack {
                    Text(category)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(amount.currencyFormatted())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/// Preview provider for AnalyticsView
#Preview {
    AnalyticsView()
        .environmentObject(ContentViewModel())
}

struct SpendingData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct CategoryData: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let percentage: Double
    let color: Color
}

struct CategoryRow: View {
    let name: String
    let amount: Double
    let percentage: Double
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
            
            Text("€\(Int(amount))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(Int(percentage))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 40)
        }
        .padding(.horizontal)
    }
}

struct InsightCard: View {
    let title: String
    let message: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

// Sample data
let sampleSpendingData = [
    SpendingData(category: "Food", amount: 350),
    SpendingData(category: "Transport", amount: 200),
    SpendingData(category: "Shopping", amount: 450),
    SpendingData(category: "Bills", amount: 800),
    SpendingData(category: "Entertainment", amount: 150)
]

let sampleCategories = [
    CategoryData(name: "Food & Dining", amount: 350, percentage: 25, color: .blue),
    CategoryData(name: "Transportation", amount: 200, percentage: 15, color: .green),
    CategoryData(name: "Shopping", amount: 450, percentage: 32, color: .orange),
    CategoryData(name: "Bills & Utilities", amount: 800, percentage: 57, color: .red),
    CategoryData(name: "Entertainment", amount: 150, percentage: 11, color: .purple)
] 