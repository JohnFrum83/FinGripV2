import SwiftUI

struct BankConnectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Connect your bank account to automatically track your transactions and manage your finances more effectively.")
                        .padding(.vertical, 8)
                }
                
                Section("Connected Banks") {
                    Text("No banks connected yet")
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button(action: {
                        // TODO: Implement bank connection flow
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Connect a Bank")
                        }
                    }
                }
            }
            .navigationTitle("Bank Connection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BankConnectionView()
} 