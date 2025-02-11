import SwiftUI

struct TransactionDocumentsSectionView: View {
    @Binding var reviewDocuments: [GenericTransactionDetailsDocuments]
    
    @State var showReviewDocumentListPopover: Bool = false
    
    var body: some View {
        GenericTransactionDetailsSectionView(
            header: {
                GenericTransactionDetailsSectionHeaderView(headerText: "Review transaction details", shouldHideBadge: true)
            },
            content: {
                TransactionDocumentsRowView(textCount: "\(reviewDocuments.count)")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showReviewDocumentListPopover.toggle()
                    }
                    .popover(isPresented: $showReviewDocumentListPopover) {
                        NavigationView {
                            TransactionDocumentListScreen(showReviewDocumentListPopover: $showReviewDocumentListPopover, reviewDocuments: $reviewDocuments)
                        }
                    }
            }
        )
    }
}

struct TransactionDocumentsRowView: View {
    let textCount: String
    var body: some View {
        HStack {
            Image("Claim", bundle: .investResources()).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).foregroundColor(.investDiscoveryBlue())
            VStack(alignment: .leading) {
                Text(textCount).fontWeight(.bold).font(.title3)
                Text("Documents to review").foregroundColor(.gray).font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
    }
}
