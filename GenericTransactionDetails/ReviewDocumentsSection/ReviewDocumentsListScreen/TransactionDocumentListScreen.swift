import SwiftUI

struct TransactionDocumentListScreen: View {
    @Binding var showReviewDocumentListPopover: Bool
    @Binding var reviewDocuments: [GenericTransactionDetailsDocuments]
    
    @State var showDocumenPopover: Bool = false
    @State var selectedDocumentToReview: GenericTransactionDetailsDocuments?
    
    var body: some View {
        List {
            GenericTransactionDetailsSectionView(
                header: {
                    GenericTransactionDetailsSectionHeaderView(headerText: "Review transaction details", shouldHideBadge: true).padding(.top)
                },
                content: {
                    ReviewDocumentSelectionHeaderRow(documentCountText: "\(reviewDocuments.count)")
                    ForEach(reviewDocuments) { document in
                        ReviewDocumentSelectionRow(text: document.complianceDescription ?? "", isActionRequired: false)
                            .onTapGesture {
                                selectedDocumentToReview = document
                                showDocumenPopover.toggle()
                            }
                    }
                }
            )
        }.popover(isPresented: $showDocumenPopover) {
            NavigationView {
                DocumentURLView(screenTitle: selectedDocumentToReview?.complianceDescription ?? "", documentId: selectedDocumentToReview?.documentId ?? "", workFlowId: selectedDocumentToReview?.workflowProcessId ?? "", shouldDisplayPDFView: $showDocumenPopover)
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showReviewDocumentListPopover.toggle()
                } label: {
                    Text("Close")
                }
            }
        }
        .navigationTitle(Text("Review transaction details"))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

}






