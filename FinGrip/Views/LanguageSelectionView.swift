import SwiftUI

/// A view that allows users to select their preferred language.
/// This view displays:
/// - A list of available languages
/// - Current language selection
/// - Language display names
///
/// The view uses a List to display language options and provides
/// visual feedback for the currently selected language.
struct LanguageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        List {
            ForEach(Language.allCases) { language in
                Button(action: {
                    localizationManager.selectedLanguage = language
                    dismiss()
                }) {
                    HStack {
                        Text(language.displayName)
                        Spacer()
                        if language == localizationManager.selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle(LocalizationKey.profileLanguage.localized)
    }
}

/// Preview provider for LanguageSelectionView
#Preview {
    NavigationView {
        LanguageSelectionView()
            .environmentObject(LocalizationManager.shared)
    }
} 