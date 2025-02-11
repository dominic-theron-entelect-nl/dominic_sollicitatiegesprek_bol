import SwiftUI

struct GenericTransactionRequiredDocumentsView: View {
    let documentName: String
    @State private var optionCount: Int = 1
    @State private var comment: String = ""
    @State private var selectedOption: String = ""
    @State private var selectedAdviserOption: String = ""
    @State private var text: String = ""
    @Binding var reviewDocument: GenericTransactionDetailsReviewDocuments?
    @Binding var shouldDisplayPDFView: Bool
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(documentName)
                    .font(.headline)
                    .listRowInsets(EdgeInsets())
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .foregroundColor(.black)
                    .textCase(.none)) {
                        //MARK: Rework this
                        NavigationLink(destination:  DocumentURLView(screenTitle: reviewDocument?.complianceDescription ?? "", documentId: reviewDocument?.documentId ?? "", workFlowId: reviewDocument?.workflowProcessId ?? "", shouldDisplayPDFView: $shouldDisplayPDFView)) {
                            HStack {
                                Image("PolicyDoc", bundle: .investResources())
                                    .frame(width: 30, height: 30)
                                Text("View document")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                ForEach(reviewDocument?.additionalInfoDetails ?? []) { document in
                    if (document.title?.lowercased() != "note to policyholder") {
                        Section(header: HStack {
                            Text(document.title ?? "")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .textCase(nil)
                            Spacer()
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 80, height: 25)
                                .overlay(
                                    Text("Required")
                                        .textCase(nil)
                                )
                        }.padding(EdgeInsets(top: 0, leading: -15, bottom: 0, trailing: -15)))
                        {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(document.subTitle ?? "")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                                if (document.additonalDescription != "") {
                                    Text(document.additonalDescription ?? "")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                }
                            }
                            ForEach(document.options ?? []) { option in
                                OptionSelectionButton(text: option.textSectionTitle ?? "",optionValue: "\(optionCount)", selectedOption: $selectedAdviserOption)
                            }
                        }
                    } else {
                        Section(header: Text("")
                            .font(.headline)
                            .listRowInsets(EdgeInsets())
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .foregroundColor(.black)
                            .textCase(.none)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(document.title ?? "")
                                        .font(.system(size: 15))
                                    Text(document.additonalDescription ?? "")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                }
                            }
                    }
                }
                
                
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        shouldDisplayPDFView.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Done")
                    }
                }
            }
            .navigationTitle(Text(documentName))
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct OptionSelectionButton: View {
    var text: String
    var optionValue: String
    @Binding var selectedOption: String
    var body: some View {
        
        Button(action: {
            selectedOption = text
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }) {
            VStack(alignment: .leading, spacing: 10){
                Text("Option " + optionValue + ":")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                HStack {
                    Text(text)
                        .foregroundColor(.black)
                    Spacer()
                    if (selectedOption == text) {
                        Image("checkmark", bundle: .investResources())
                           .frame(width: 30,height: 30)
                    }
                    
                }
            }
            
        }
    }
}
