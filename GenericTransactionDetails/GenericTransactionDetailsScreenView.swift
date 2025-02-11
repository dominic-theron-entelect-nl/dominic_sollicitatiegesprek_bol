import SwiftUI

struct GenericTransactionDetailsScreenView: View {
    let referenceId: String
    let correlationId: String?
    let parentViewController: ConsentActionsListViewController
    let navController: UINavigationController?
    let consentActionsList: ConsentActionsList?
    let actionItemTitle: String
    @ObservedObject var transactionDetails: GenericTransactionDetailsModel = GenericTransactionDetailsModel()
    @State var showSuccessViewPopover: Bool = false
    @State var showPutApproveOrDeclineTryAgainViewDialog: Bool = false
    @State var showDeclineConfirmationViewDialog: Bool = false
    @State var navigateToDeclineReasonView: Bool = false
    @State var shouldApproveActionItem: Bool = false
    @State var didAgreeToPleaseTakeNoteConditions: Bool = false
    
    private func errorOccuredView() -> some View {
        VStack {
            Text("Unable to load")
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            Text("An error occurred when trying to load this screen. Please try again.")
                .multilineTextAlignment(.center)
                .foregroundColor(.investDarkGray())
                .padding([.leading, .trailing, .bottom])
            Button(action: {
                transactionDetails.errorMessage = nil
                transactionDetails.fetchData(referenceId: referenceId, correlationId: correlationId) {}
            }) {
                Text("Try again")
                    .padding()
            }
            .frame(width: 200, height: 45)
            .foregroundColor(.white)
            .background(Color.investDiscoveryBlue())
            .padding()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.investLightGray())
            .ignoresSafeArea(.all)
    }
    
    var body: some View {
        VStack {
            if transactionDetails.isLoadingData {
                GenericTransactionDetailsLoadingView()
            } else if transactionDetails.errorMessage != nil {
                errorOccuredView()
            } else {
                List {
                    if transactionDetails.transactionDetailsDoc.count > 1 {
                        TransactionDocumentsSectionView(reviewDocuments: $transactionDetails.transactionDetailsDoc)
                    } else {
                        if let documentId = transactionDetails.transactionDetailsDoc.first?.documentId, let workflowId = transactionDetails.transactionDetailsDoc.first?.workflowProcessId {
                            ReviewUpdatedDetailsSectionView(updateDetailsToReviewText: getDocumentSectionDisplayName(), documentId: documentId, workFlowId: workflowId)
                        }
                    }
                    if transactionDetails.reviewDocuments.count > 0 {
                        ReviewDocumentsSectionView(reviewDocuments: $transactionDetails.reviewDocuments, didAgreeToPleaseTakeNoteConditions: $didAgreeToPleaseTakeNoteConditions)
                    }
                    if transactionDetails.approvalOptions.count > 0 {
                        SubmitApprovalSectionView(approvalOptions: $transactionDetails.approvalOptions, referenceNumber: $transactionDetails.workflowId)
                    }
                    if transactionDetails.textNote.count > 0 {
                        NoteFromYourAdvisorSectionView(noteFromAdvisorText: $transactionDetails.textNote)
                    }
                }.popover(isPresented: $showSuccessViewPopover) {
                    NavigationView {
                        TransactionSuccessView(reference: $transactionDetails.workflowId, typeCode: getActionItemTypeCode())
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        showSuccessViewPopover.toggle()
                                        if (consentActionsList?.actionItems.count ?? 0 == 1)
                                        {
                                            guard
                                                let thisViewIndex = navController?.viewControllers.firstIndex(of: parentViewController),
                                                let previousViewIndex = navController?.viewControllers.index(before: thisViewIndex),
                                                let viewToPopTo = navController?.viewControllers.element(at: previousViewIndex)
                                            else {
                                                return
                                            }
                                            navController?.popToViewController(viewToPopTo, animated: true)
                                        } else if let navController = parentViewController.navigationController {
                                            navController.popViewController(animated: true)
                                        }
                                    } label: {
                                        Text("Done")
                                    }
                                }
                            }
                            .navigationTitle(Text("Success"))
                            .listStyle(.insetGrouped)
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarBackButtonHidden(true)
                    }
                }
                
                HStack {
                    NavigationLink(destination: GenericTransactionDeclined(rejectReasons: $transactionDetails.rejectReasonsModel, comment: $transactionDetails.comment, selectedReason: $transactionDetails.selectedReason, parentViewController: parentViewController, referenceId: transactionDetails.referenceId, workflowId: transactionDetails.workflowId, correlationId: transactionDetails.correlationId, actionItemCount: consentActionsList?.actionItems.count ?? 0, isNavFromNonGenericSwitchesFlow: false).navigationBarBackButtonHidden(true)
                        .navigationTitle("Transaction declined")
                                   , isActive: $navigateToDeclineReasonView) {
                        EmptyView()
                    }.alert(isPresented: $showDeclineConfirmationViewDialog) {
                        Alert(title: Text("Are you sure you want to decline this transaction?"), message: Text("Rejecting this transaction would require you to contact your financial adviser to update the details again"),
                              primaryButton: .destructive(Text("Decline")) {
                            shouldApproveActionItem = false
                            submitActionItemApproval()
                        }, secondaryButton: .cancel())
                    }
                    Button(action: {
                        showDeclineConfirmationViewDialog.toggle()
                    }, label: {
                        Text("Decline").foregroundColor(.red)
                    })
                    Spacer()
                    Button(action: {
                        shouldApproveActionItem = true
                        submitActionItemApproval()
                    }, label: {
                        Text("Approve").foregroundColor(transactionDetails.canApprove() ? .investDiscoveryBlue() : .investDarkGray())
                    }).alert(isPresented: $showPutApproveOrDeclineTryAgainViewDialog) {
                        Alert(title: Text("Unable to send your request"), message: Text("An error occurred while trying to send your request. Please try again."),
                              primaryButton: .default(Text("Try again")){
                            submitActionItemApproval()
                        }, secondaryButton: .cancel())
                    }.disabled(!transactionDetails.canApprove())
                }
                .frame(alignment: .bottom).padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", action: {
                    parentViewController.navigationController?.popViewController(animated: true)
                }).foregroundColor(.investDiscoveryBlue())
            }
        }
        .onAppear(perform: {
            transactionDetails.fetchData(referenceId: referenceId, correlationId: correlationId){}
        })
    }
    
    func getDocumentSectionDisplayName() -> String {
        return transactionDetails.documentToReview.count > 0 ? transactionDetails.documentToReview : actionItemTitle
    }
    
    func getActionItemTypeCode() -> Int {
        guard let typeCode = transactionDetails.typeCode else {
            return 0
        }
        return typeCode
    }
    
    func submitActionItemApproval() {
        transactionDetails.isLoadingData = true
        transactionDetails.putActionItemApprovalOrDecline(approved: shouldApproveActionItem) { success in
            transactionDetails.isLoadingData = false
            DispatchQueue.main.async {
                if success {
                    if shouldApproveActionItem {
                        showSuccessViewPopover.toggle()
                    } else {
                        navigateToDeclineReasonView.toggle()
                    }
                } else {
                    showPutApproveOrDeclineTryAgainViewDialog.toggle()
                }
            }
        }
    }
}

struct GenericTransactionDetailsLoadingView: View {
    var body: some View {
        HStack {
            ProgressView().progressViewStyle(.circular)
            Text("Loading...")
                .padding(.leading, 8)
                .foregroundColor(Color.black.opacity(0.3))
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.investLightGray())
            .ignoresSafeArea(.all)
    }
}

struct GenericTransactionDetailsSectionView<Header: View, Content: View, Footer: View>: View {
    let header: () -> Header
    let content: () -> Content
    let footer: () -> Footer?
    
    init(@ViewBuilder header: @escaping () -> Header,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder footer: @escaping () -> Footer? = {EmptyView()}) {
        self.header = header
        self.content = content
        self.footer = footer
    }
    
    var body: some View {
        Section(header: header(), footer: footer()) {
            content()
        }
    }
}

struct GenericTransactionDetailsSectionHeaderView: View {
    let headerText: String
    let shouldHideBadge: Bool?
    private let badgeText: String = "Required"
    var body: some View {
        HStack {
            Text(headerText)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .textCase(nil)
            Spacer()
            Capsule()
                .fill(Color.white)
                .frame(width: 80, height: 25)
                .overlay(
                    Text(badgeText)
                        .textCase(nil)
                ).hidden(shouldHideBadge ?? true)
        }.padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15))
    }
}

struct GenericTransactionDetailsSectionFooterView: View {
    let footerText: String
    let referenceNumber: String
    var body: some View {
        HStack(alignment: .center) {
            Text(footerText).font(.footnote)
            Button(action: actionSheet, label: {
                Text(referenceNumber).font(.footnote).foregroundColor(.investDiscoveryBlue())
            })
        }.padding(EdgeInsets(top: 10, leading: -15, bottom: 0, trailing: 0))
    }
    
    func actionSheet() {
        let av = UIActivityViewController(activityItems: [referenceNumber], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
