import SwiftUI

class SpendingCategoryViewModel: ObservableObject {
    @Published var categories: [SpendingCategory]
    @Published var selectedCategory: SpendingCategory?
    
    init(categories: [SpendingCategory] = SpendingCategory.defaultCategories) {
        self.categories = categories
    }
    
    func addCategory(_ category: SpendingCategory) {
        categories.append(category)
    }
    
    func updateCategory(_ category: SpendingCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
        }
    }
    
    func deleteCategory(_ category: SpendingCategory) {
        categories.removeAll { $0.id == category.id }
    }
    
    func updateBudget(for category: SpendingCategory, amount: Double) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].budget = amount
        }
    }
    
    func updateSpending(for category: SpendingCategory, amount: Double) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index].totalSpent += amount
        }
    }
    
    func resetSpending() {
        for index in categories.indices {
            categories[index].totalSpent = 0
        }
    }
    
    func getBudgetProgress(for category: SpendingCategory) -> Double {
        guard category.budget > 0 else { return 0 }
        return min(category.totalSpent / category.budget, 1.0)
    }
    
    func isOverBudget(_ category: SpendingCategory) -> Bool {
        category.budget > 0 && category.totalSpent > category.budget
    }
} 