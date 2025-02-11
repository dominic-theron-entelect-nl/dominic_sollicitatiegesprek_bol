import SwiftUI

struct ReviewDocumentsSectionView: View {
    @Binding var reviewDocuments: [GenericTransactionDetailsReviewDocuments]
    
    @State var showReviewDocumentListPopover: Bool = false
    
    @Binding var didAgreeToPleaseTakeNoteConditions: Bool
    
    var body: some View {
        GenericTransactionDetailsSectionView(
            header: {
                GenericTransactionDetailsSectionHeaderView(headerText: "Review documents", shouldHideBadge: !reviewDocuments.contains(where: { document in
                    document.isRequired
                }))
            },
            content: {
                ReviewDocumentsRowView(textCount: "\(reviewDocuments.count)")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showReviewDocumentListPopover.toggle()
                    }
                    .popover(isPresented: $showReviewDocumentListPopover) {
                        NavigationView {
                            ReviewDocumentSelectionScreenView(showReviewDocumentListPopover: $showReviewDocumentListPopover, reviewDocuments: $reviewDocuments, didAgreeToPleaseTakeNoteConditions: $didAgreeToPleaseTakeNoteConditions)
                        }
                    }
            }
        )
    }
}

struct ReviewDocumentsRowView: View {
    let textCount: String
    var body: some View {
        HStack {
            Image("Document_Search", bundle: .investResources()).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).foregroundColor(.investDiscoveryBlue())
            VStack(alignment: .leading) {
                Text(textCount).fontWeight(.bold).font(.title3)
                Text("Documents to review").foregroundColor(.gray).font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
    }
}
