import PDFKit
import SwiftUI
import WSGKit

struct DocumentURLView: View {
    var screenTitle: String
    var documentId: String
    var workFlowId: String
    @State private var dynamicTitle: String = "Document loading"
    @State var pdfData: Data?
    @State var isDisplayingShareSheet: Bool = false
    @Binding var shouldDisplayPDFView: Bool
    
    var body: some View {
        VStack {
            if let data = pdfData {
                PDFKitRepresentedView(data)
                    .sheet(isPresented: $isDisplayingShareSheet) {
                        PDFShareSheetView(pdfData: data)
                    }
            } else {
                List {
                    Section {
                        VStack {
                            Spacer()
                            Image("Download", bundle: .investResources())
                                .resizable()
                                .frame(width: 120, height: 120)
                                .aspectRatio(contentMode: .fit)
                            Text("Document loading")
                                .multilineTextAlignment(.center)
                                .font(.openSansBold(size: 20))
                            Spacer()
                            Text("The document is being loaded. This may take a while.")
                                .foregroundColor(.gray)
                                .font(.openSansRegular(size: 15))
                                .multilineTextAlignment(.center)
                            ProgressView()
                                .frame(width: 35, height: 35)
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear {
            WSGKit.sharedManager().requestDocumentData(workflowId: workFlowId, documentId: documentId) { data, error in
                if let pdfData = data {
                    DispatchQueue.main.async {
                        self.pdfData = pdfData
                        dynamicTitle = screenTitle
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button("Close"){
                    shouldDisplayPDFView.toggle()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isDisplayingShareSheet.toggle()
                } label: {
                    Label("", systemImage: "square.and.arrow.up")
                }
                
            }
        }
        .navigationTitle(Text(dynamicTitle))
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    struct PDFShareSheetView: View {
        var pdfData: Data
        var body: some View {
            PDFShareSheet(activityItems: [pdfData])
        }
    }
    
    struct PDFShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return controller
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    typealias UIViewType = PDFView
    
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
    }
}
