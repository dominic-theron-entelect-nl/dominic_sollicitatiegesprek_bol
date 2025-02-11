import SwiftUI

struct ReviewUpdatedDetailsSectionView: View {
    let updateDetailsToReviewText: String
    let documentId: String
    let workFlowId: String
    @State var showReviewDocumentListPopover: Bool = false
    var body: some View {
        GenericTransactionDetailsSectionView(
            header: {
                GenericTransactionDetailsSectionHeaderView(headerText: "Review transaction details", shouldHideBadge: true).padding(.top)
            },
            content: {
                ReviewUpdateDetailsRow(text: updateDetailsToReviewText)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showReviewDocumentListPopover.toggle()
                    }
                    .popover(isPresented: $showReviewDocumentListPopover) {
                        NavigationView {
                            DocumentURLView(screenTitle: updateDetailsToReviewText, documentId: documentId, workFlowId: workFlowId ,shouldDisplayPDFView: $showReviewDocumentListPopover)
                        }
                    }
            }
        )
    }
}

struct ReviewUpdateDetailsRow: View {
    let text: String
    var body: some View {
        HStack {
            Image("Claim", bundle: .investResources()).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).foregroundColor(.investDiscoveryBlue())
            Text(text)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
    }
}
