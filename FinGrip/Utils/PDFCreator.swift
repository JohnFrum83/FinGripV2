import PDFKit
import UIKit

class PDFCreator {
    static func createSubscriptionReport(subscriptions: [Subscription]) -> Data {
        // Setup PDF metadata and format
        let pdfMetaData = [
            kCGPDFContextCreator: "FinGrip",
            kCGPDFContextAuthor: "FinGrip Subscription Manager"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Setup page size (US Letter)
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // Create PDF renderer
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        // Generate PDF
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Draw header
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let titleAttributes = [NSAttributedString.Key.font: titleFont]
            let titleText = "Subscription Report"
            let titleRect = CGRect(x: 50, y: 50, width: pageWidth - 100, height: 50)
            titleText.draw(in: titleRect, withAttributes: titleAttributes)
            
            // Draw date
            let dateFont = UIFont.systemFont(ofSize: 12)
            let dateAttributes = [NSAttributedString.Key.font: dateFont]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            let dateText = "Generated on: \(dateFormatter.string(from: Date()))"
            let dateRect = CGRect(x: 50, y: 80, width: pageWidth - 100, height: 20)
            dateText.draw(in: dateRect, withAttributes: dateAttributes)
            
            // Draw summary
            let summaryFont = UIFont.systemFont(ofSize: 14)
            let summaryAttributes = [NSAttributedString.Key.font: summaryFont]
            let totalMonthly = subscriptions.reduce(0) { $0 + $1.monthlyAmount }
            let summaryText = "Total Monthly Spend: \(totalMonthly.currencyFormatted())"
            let summaryRect = CGRect(x: 50, y: 110, width: pageWidth - 100, height: 30)
            summaryText.draw(in: summaryRect, withAttributes: summaryAttributes)
            
            // Draw table headers
            let headerFont = UIFont.boldSystemFont(ofSize: 12)
            let headerAttributes = [NSAttributedString.Key.font: headerFont]
            var yPosition: CGFloat = 150
            let columnWidth = (pageWidth - 100) / 4
            
            ["Name", "Category", "Billing Cycle", "Monthly Amount"].enumerated().forEach { index, header in
                let headerRect = CGRect(x: 50 + CGFloat(index) * columnWidth, y: yPosition, width: columnWidth, height: 20)
                header.draw(in: headerRect, withAttributes: headerAttributes)
            }
            
            // Draw subscriptions
            let contentFont = UIFont.systemFont(ofSize: 12)
            let contentAttributes = [NSAttributedString.Key.font: contentFont]
            yPosition += 25
            
            for subscription in subscriptions {
                let rowData = [
                    subscription.name,
                    subscription.category.rawValue.capitalized,
                    subscription.billingCycle.rawValue.capitalized,
                    subscription.monthlyAmount.currencyFormatted()
                ]
                
                rowData.enumerated().forEach { index, content in
                    let contentRect = CGRect(x: 50 + CGFloat(index) * columnWidth, y: yPosition, width: columnWidth, height: 20)
                    content.draw(in: contentRect, withAttributes: contentAttributes)
                }
                
                yPosition += 25
                
                // Add new page if needed
                if yPosition > pageHeight - 50 {
                    context.beginPage()
                    yPosition = 50
                }
            }
        }
        
        return data
    }
} 