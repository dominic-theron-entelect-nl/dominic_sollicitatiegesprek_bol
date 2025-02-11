import SwiftUI

class GenericTransactionDetailsModel: ObservableObject {
    @Published var textNote: String = ""
    @Published var workflowId: String = ""
    @Published var referenceId: String = ""
    @Published var correlationId: String = ""
    @Published var documentToReview: String = ""
    @Published var typeCode: Int?
    @Published var reviewDocuments: [GenericTransactionDetailsReviewDocuments] = []
    @Published var approvalOptions: [GenericTransactionDetailsApprovalOptions] = []
    @Published var rejectReasonsModel: [GenericTransactionRejectReasonModel] = []
    @Published var comment: String = ""
    @Published var selectedReason: String = ""
    @Published var transactionDetailsDoc : [GenericTransactionDetailsDocuments] = []
    @Published var errorMessage: WSGError? = nil
    @Published var isLoadingData: Bool = false
    
    func fetchData(referenceId: String, correlationId: String?, completion: @escaping() -> Void) {
        isLoadingData = true
        self.referenceId = referenceId
        self.correlationId = correlationId ?? ""
        ConsentActionsListService().fetchConsentGenericActionItemDetails(for: referenceId) { [weak self] consentGenericActionItemDetailsResponse, wsgError in
            ///Since the model is used throughout we need to be sure to clear out all old data when the fetch happens again!
            ///In case of a retry with partial data we want a complete copy with no partial data from before
            self?.reviewDocuments = []
            self?.approvalOptions = []
            self?.rejectReasonsModel = []
            self?.workflowId = consentGenericActionItemDetailsResponse?.workflowId ?? ""
            self?.textNote = consentGenericActionItemDetailsResponse?.details?.reviewUpdatedDetails?.advisorNote?.brokerNote ?? ""
            self?.typeCode = consentGenericActionItemDetailsResponse?.typeCode
            
            // MARK: Prevents crash if no Transaction Detail docs returned from service
            if !(consentGenericActionItemDetailsResponse?.details?.documents?.transactionDetailsDocs.isEmpty ?? false) {
                if let docs = consentGenericActionItemDetailsResponse?.details?.documents?.transactionDetailsDocs.first {
                    self?.documentToReview = docs.name ?? ""
                }
                consentGenericActionItemDetailsResponse?.details?.documents?.transactionDetailsDocs.forEach({ transactionDocument in
                    self?.transactionDetailsDoc.append(GenericTransactionDetailsDocuments(documentId: transactionDocument.documentId ?? "", documentURL: transactionDocument.documentURL ?? "", workflowProcessId: transactionDocument.workflowProcessId ?? "", documentImageClassCode: transactionDocument.documentImageClassCode ?? "", complianceDescription: transactionDocument.complianceDescription ?? "", name: transactionDocument.name ?? "", description: transactionDocument.docDescription ?? "", actionRequired: transactionDocument.actionRequired ?? false))
                })
            }
            consentGenericActionItemDetailsResponse?.details?.documents?.reviewDocs.forEach({ complianceDocument in
                self?.reviewDocuments.append(GenericTransactionDetailsReviewDocuments(
                    isRequired: complianceDocument.actionRequired ?? false,
                    isActioned: (complianceDocument.actionRequired ?? false) ? false : true,
                    documentId: complianceDocument.documentId,
                    workflowProcessId: complianceDocument.workflowProcessId,
                    complianceDescription: complianceDocument.complianceDescription
                ))
            })
            consentGenericActionItemDetailsResponse?.details?.declines?.rejectReasons.forEach({ rejectReason in
                self?.rejectReasonsModel.append(GenericTransactionRejectReasonModel(
                    value: rejectReason.value ?? "",
                    label: rejectReason.label ?? ""
                ))
            })
            consentGenericActionItemDetailsResponse?.details?.approvals?.forEach({ approvalString in
                self?.approvalOptions.append(GenericTransactionDetailsApprovalOptions(optionText: approvalString))
            })
            self?.errorMessage = wsgError
            
            ///Remeber to indicate to the view that the data fetch is complete
            self?.isLoadingData = false
            completion()
        }
    }
    
    func canApprove() -> Bool {
        return !approvalOptions.contains { $0.isSelected == false } && !reviewDocuments.contains { $0.isActioned == false }
    }
    
    func putActionItemApprovalOrDecline(approved: Bool, _ completion:@escaping(_ success: Bool) -> ()) {
        ConsentActionsListService().updateConsentActionItemStatus(for: referenceId, with: workflowId, to: approved, correlationId: correlationId) { [weak self] updateActionItemStatusResponse, wsgError in
            guard let self = self, let responseSuccess = updateActionItemStatusResponse?.success else {
                completion(false)
                return
            }
            completion(responseSuccess)
        }
    }
}

struct GenericTransactionDetailsApprovalOptions {
    var optionText: String
    var isSelected: Bool = false
}

struct GenericTransactionDetailsReviewDocuments: Identifiable {
    let id = UUID()
    var isRequired: Bool = false
    var isActioned: Bool = true
    var documentId: String?
    var workflowProcessId: String?
    var complianceDescription: String?
    var additionalInfoDetails: [GenericTransactionAdditionalInfoDetail]?
}

struct GenericTransactionDetailsDocuments: Identifiable {
    let id = UUID()
    var documentId : String?
    var documentURL : String?
    var workflowProcessId : String?
    var documentImageClassCode : String?
    var complianceDescription: String?
    var name: String?
    var description: String?
    var actionRequired: Bool = false
    var uploadDate: String?
}

struct GenericTransactionRejectReasonModel: Identifiable {
    var id = UUID()
    var value: String?
    var label: String?
}

struct GenericTransactionAdditionalInfoDetail: Identifiable {
    var id = UUID()
    var title: String?
    var subTitle: String?
    var additonalDescription: String?
    var options: [GenericTransactionAdditionalInfoDetailOption]?
}

struct GenericTransactionAdditionalInfoDetailOption: Identifiable {
    var id = UUID()
    var textSectionTitle: String?
    var textValue: String?
    var selected: Bool
}
