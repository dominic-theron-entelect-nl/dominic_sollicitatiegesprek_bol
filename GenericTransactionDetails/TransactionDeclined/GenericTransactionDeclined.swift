import SwiftUI

struct GenericTransactionDeclined: View {
    @Binding var rejectReasons: [GenericTransactionRejectReasonModel]
    @Binding var comment: String
    @Binding var selectedReason: String
    @State var showDeclineReasonTryAgainDialog: Bool = false
    @State var retryCountDeclineReason: Int = 0
    @State var wasSuccessful: Bool = false
    
    let parentViewController: UIViewController
    let referenceId: String
    let workflowId: String
    let correlationId: String
    let actionItemCount: Int
    let isNavFromNonGenericSwitchesFlow: Bool
    
    private func submitRejectReasonRequest(_ callback: @escaping (_ result: Bool?) -> ()) {
        ConsentActionsListService().fetchConsentActionItemSaveRejectReason(for: referenceId, workflowId: workflowId, correlationId: correlationId, rejectReason: selectedReason, comment: comment) { actionItemSaveRejectReasonResponse, wsgError in
            if let response = actionItemSaveRejectReasonResponse {
                callback(response.success)
            }
            callback(false)
        }
    }
    
    private func navigateBack() {
        if (actionItemCount <= 1)
        {
            guard
                let thisViewIndex = parentViewController.navigationController?.viewControllers.firstIndex(of: parentViewController),
                let previousViewIndex = parentViewController.navigationController?.viewControllers.index(before: thisViewIndex),
                let viewToPopTo = parentViewController.navigationController?.viewControllers.element(at: previousViewIndex)
            else {
                return
            }
            parentViewController.navigationController?.popToViewController(viewToPopTo, animated: true)
        } else if let navController = parentViewController.navigationController {
            if(isNavFromNonGenericSwitchesFlow) {
                guard
                    let thisViewIndex = parentViewController.navigationController?.viewControllers.firstIndex(of: parentViewController),
                    let viewToPopTo = parentViewController.navigationController?.viewControllers.element(at: thisViewIndex)
                else {
                    return
                }
                parentViewController.navigationController?.popToViewController(viewToPopTo, animated: true)
            } else {
                navController.popViewController(animated: true)
                navController.popViewController(animated: true)
            }
        }
    }
    
    func submitDeclineReasonAndUpdateViews() {
        submitRejectReasonRequest { result in
            if result ?? false {
                navigateBack()
                wasSuccessful.toggle()
            } else if (!wasSuccessful) {
                showDeclineReasonTryAgainDialog.toggle()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_TRANSACTION_DECLINED_HEADER"))
                    .font(.headline)
                    .listRowInsets(EdgeInsets())
                    .foregroundColor(Color.black)
                    .padding(.top, 35)
                    .padding(.bottom, 10)
                    .textCase(.none)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_TRANSACTION_DECLINED_SUB_HEADER"))
                                .foregroundColor(.gray)
                                .font(.callout)
                            Text(InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_TRANSACTION_DECLINED_OPTION"))
                                .foregroundColor(.gray)
                                .font(.footnote)
                                .padding(.bottom, 10)
                        }.listRowBackground(Color.white)
                        ForEach($rejectReasons, id:\.id) { $rejectReason in
                            GenericOptionButtonView(text: $rejectReason.label, value: $rejectReason.value, selectedOption: $selectedReason)
                        }
                    }
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_LEAVE_COMMENT"))
                            .foregroundColor(Color.investDiscoveryBlue())
                            .font(.callout)
                            .padding(.top, 5)
                        ZStack(alignment: .topLeading){
                            if comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text(InvestLocalizedString(key: "ACTION_ITEM_GENERIC_SERVICE_ADDITIONAL_COMMENTS"))
                                    .font(.body)
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.top, 8)
                            }
                            TextEditor(text: $comment).padding(.leading, -3)
                        }
                        if (selectedReason.uppercased() == "OTHER") {
                            Text("Required")
                                .foregroundColor(comment.isEmpty ? .red : .green)
                                .font(.footnote)
                                .padding(.bottom, 5)
                                .padding(.top, -25)
                        }
                    }
                }
            }.alert(isPresented: $showDeclineReasonTryAgainDialog) {
                Alert(title: Text("Unable to send your request"), message: Text("An error occurred while trying to send your request. Please try again."),
                      primaryButton: .default(Text("Try again")) {
                    retryCountDeclineReason+=1
                    if retryCountDeclineReason > 2 {
                        navigateBack()
                    }
                }, secondaryButton: .cancel())
            }
            .listStyle(.insetGrouped)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Submit") {
                    submitDeclineReasonAndUpdateViews()
                }.disabled(selectedReason == "" || (selectedReason == "OTHER" && comment == ""))
            }
        }
    }
}
