import SwiftUI

struct ReviewDocumentSelectionScreenView: View {
    @Binding var showReviewDocumentListPopover: Bool
    @Binding var reviewDocuments: [GenericTransactionDetailsReviewDocuments]
    
    @State var showCorrectFlowViewPopover: Bool = false
    @State var selectedDocumentToReview: GenericTransactionDetailsReviewDocuments?
    
    @Binding var didAgreeToPleaseTakeNoteConditions: Bool
    
    var body: some View {
        List {
            GenericTransactionDetailsSectionView(
                header: {
                    GenericTransactionDetailsSectionHeaderView(headerText: "Review documents", shouldHideBadge: shouldHideBadge()).padding(.top)
                },
                content: {
                    ReviewDocumentSelectionHeaderRow(documentCountText: "\(reviewDocuments.count)")
                    ForEach(reviewDocuments) { document in
                        ReviewDocumentSelectionRow(text: document.complianceDescription ?? "", isActionRequired: document.isRequired)
                            .onTapGesture {
                                selectedDocumentToReview = document
                                showCorrectFlowViewPopover.toggle()
                            }
                    }
                }
            )
        }.popover(isPresented: $showCorrectFlowViewPopover) {
            let isRequired = selectedDocumentToReview?.isRequired ?? false
            if(didAgreeToPleaseTakeNoteConditions && !isRequired) {
                NavigationView {
                    DocumentURLView(screenTitle: selectedDocumentToReview?.complianceDescription ?? "", documentId: selectedDocumentToReview?.documentId ?? "", workFlowId: selectedDocumentToReview?.workflowProcessId ?? "", shouldDisplayPDFView: $showCorrectFlowViewPopover)
                }
            } else {
                if (isRequired) {
                    GenericTransactionRequiredDocumentsView(documentName: selectedDocumentToReview?.complianceDescription ?? "", reviewDocument: $selectedDocumentToReview, shouldDisplayPDFView: $showCorrectFlowViewPopover)
                } else {
                    PleaseTakeNoteScreenView(showPleaseTakeNoteScreen: $showCorrectFlowViewPopover, didAgreeToConditions: $didAgreeToPleaseTakeNoteConditions)
                }
     
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
        .navigationTitle(Text("Review documents"))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private func shouldHideBadge() -> Bool {
        return !reviewDocuments.contains{$0.isRequired}
    }
}

struct ReviewDocumentSelectionRow: View {
    var text: String
    var isActionRequired: Bool
    var body: some View {
        HStack {
            Text(text).lineLimit(1)
            Spacer()
            if isActionRequired {
                Text("Action required").foregroundColor(.red)
            }
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
    }
}

struct ReviewDocumentSelectionHeaderRow: View {
    var documentCountText: String
    private let ICON_SIZE: CGFloat = 50
    var body: some View {
        HStack {
            Image("Document_Search", bundle: .investResources())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: ICON_SIZE, height: ICON_SIZE)
            VStack (alignment: .leading) {
                Text(documentCountText)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Documents to review")
                    .font(.callout)
                    .foregroundColor(.investDarkGray())
            }
        }
    }
}
