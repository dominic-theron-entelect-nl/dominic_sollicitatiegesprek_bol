import SwiftUI

struct TransactionSuccessView: View {
    @State private var isShareSheetPresented = false
    @Binding var reference: String
    var typeCode: Int
    var body: some View {
        List {
            Section {
                VStack(alignment: .center, spacing: 15) {
                    Image("TransactionSuccess", bundle: .investResources()).resizable().aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .padding(.top, 35)
                    Text(InvestLocalizedString(key: "CONSENT_DETAIL_SUCCESS_CONTENT_TITLE"))
                        .font(Font.title.weight(.bold))
                        .multilineTextAlignment(.center)
                    Text(InvestLocalizedString(key: "CONSENT_DETAIL_SUCCESS_CONTENT_DETAIL"))
                        .foregroundColor(.gray)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                    Text(InvestLocalizedString(key: "GENERIC_REFERENCE_NUMBER"))
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding(.top, 35)
                    Text(reference)
                        .font(.headline)
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color.investDiscoveryBlue())
                        .padding(.bottom, 35)
                        .onTapGesture {
                            isShareSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isShareSheetPresented) {
                            GenericShareSheetView(reference: reference)
                        }
                }.frame(maxWidth: .infinity)
            }
            Section {
                ///Payments : Savings Withdrawal
                if (typeCode == 24) {
                    Group {
                        Text(InvestLocalizedString(key: "CONSENT_SUCCESS_FOOTER_TWO_POTS"))
                            .foregroundColor(.gray)
                            .font(.footnote) +
                        Text(InvestLocalizedString(key: "CONSENT_SUCCESS_FOOTER_NUMBER"))
                            .font(.footnote)
                            .foregroundColor(.investDiscoveryBlue())
                    }.multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .onTapGesture {
                        openDialer()
                    }
                } else {
                    Text(InvestLocalizedString(key: "CONSENT_SUCCESS_FOOTER"))
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                }
            }
        }
    }
    
    private func openDialer() {
        let phoneNumber = InvestLocalizedString(key: "CONSENT_SUCCESS_FOOTER_NUMBER")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
        let string = String(format: "tel:%@", phoneNumber)
        if let url = NSURL(string: string) {
            MEMAnalytics.track(action: .tap, category: .investRevamp, label: "transaction_submitted_contact_invest")
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

struct GenericShareSheetView: View {
    var reference: String
    var body: some View {
        ShareSheet(activityItems: [reference])
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
}
