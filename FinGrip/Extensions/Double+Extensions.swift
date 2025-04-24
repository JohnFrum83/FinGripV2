import Foundation

extension Double {
    func currencyFormatted() -> String {
        return LocalizationManager.shared.formatCurrency(self)
    }
    
    func percentFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return formatter.string(from: NSNumber(value: self / 100)) ?? "\(self)%"
    }
} 