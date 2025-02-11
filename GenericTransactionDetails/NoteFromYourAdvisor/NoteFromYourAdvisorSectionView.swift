import SwiftUI

struct NoteFromYourAdvisorSectionView: View {
    @Binding var noteFromAdvisorText: String
    var body: some View {
        GenericTransactionDetailsSectionView(
            header: {
                GenericTransactionDetailsSectionHeaderView(headerText: noteFromYourAdvisorTitle(), shouldHideBadge: true)
            },
            content: {
                Text("\"\(noteFromAdvisorText)\"")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        )
    }
}

extension NoteFromYourAdvisorSectionView {
    private func noteFromYourAdvisorTitle() -> String {
        return InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_NOTE_FROM_YOUR_ADVISOR")
    }
}
