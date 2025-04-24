import SwiftUI
import Charts

struct SavingsView: View {
    @StateObject private var viewModel: ContentViewModel
    @State private var selectedCategory: FinancialCategory?
    @State private var showingNewOpportunitySheet = false
    
    init(viewModel: ContentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var implementedSavings: [ImplementedSaving] {
        if let category = selectedCategory {
            return viewModel.savingsTracker.implementedSavings.filter { $0.opportunity.category == category }
        }
        return viewModel.savingsTracker.implementedSavings
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Cards
                HStack(spacing: 16) {
                    VStack {
                        Text("Total Saved")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.totalSaved.currencyFormatted())
                            .font(.title2)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    VStack {
                        Text("Opportunities")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.savingsTracker.opportunities.count)")
                            .font(.title2)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                // Implemented Savings List
                if !implementedSavings.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Implemented Savings")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(implementedSavings) { saving in
                            ImplementedSavingRow(saving: saving)
                                .padding(.horizontal)
                        }
                    }
                }
                
                // Opportunities List
                if !viewModel.savingsTracker.opportunities.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Available Opportunities")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.savingsTracker.opportunities) { opportunity in
                            if !opportunity.isImplemented {
                                SavingOpportunityRow(opportunity: opportunity) {
                                    viewModel.implementSaving(opportunity, savedAmount: opportunity.potentialSavingsAmount)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Savings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingNewOpportunitySheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewOpportunitySheet) {
            AddSavingOpportunityView(viewModel: viewModel)
        }
    }
}

struct ImplementedSavingRow: View {
    let saving: ImplementedSaving
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(saving.opportunity.title)
                    .font(.headline)
                Text(saving.opportunity.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(saving.amount.currencyFormatted())
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct SavingOpportunityRow: View {
    let opportunity: SavingOpportunity
    let onImplement: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(opportunity.title)
                    .font(.headline)
                Text(opportunity.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onImplement) {
                Text("Implement")
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
} 