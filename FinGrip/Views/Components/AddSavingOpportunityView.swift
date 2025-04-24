import SwiftUI

struct AddSavingOpportunityView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ContentViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var amount = ""
    @State private var category: FinancialCategory = .housing
    @State private var difficulty: SavingOpportunity.Difficulty = .easy
    @State private var timeframe: SavingOpportunity.Timeframe = .immediate
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Potential Savings Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $category) {
                        ForEach(FinancialCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(SavingOpportunity.Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue)
                                .tag(difficulty)
                        }
                    }
                    Picker("Timeframe", selection: $timeframe) {
                        ForEach(SavingOpportunity.Timeframe.allCases, id: \.self) { timeframe in
                            Text(timeframe.rawValue)
                                .tag(timeframe)
                        }
                    }
                }
            }
            .navigationTitle("Add Saving Opportunity")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    if let amountValue = Double(amount) {
                        let opportunity = SavingOpportunity(
                            title: title,
                            description: description,
                            potentialSavingsAmount: amountValue,
                            category: category,
                            timeframe: timeframe,
                            difficulty: difficulty,
                            isImplemented: false
                        )
                        viewModel.savingsTracker.addOpportunity(opportunity)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || description.isEmpty || amount.isEmpty)
            )
        }
    }
} 