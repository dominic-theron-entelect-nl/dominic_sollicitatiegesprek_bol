import SwiftUI
struct PleaseTakeNoteScreenView: View {
    @Binding var showPleaseTakeNoteScreen: Bool
    @Binding var didAgreeToConditions: Bool
    let imageSize = 120.0
    var body: some View {
        NavigationView {
            List {
                Section{
                    VStack {
                        Spacer()
                        Image("Document_Shield_Generic", bundle: .investResources()).resizable().aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                        Text("No physical signatures required")
                            .multilineTextAlignment(.center)
                            .font(.openSansBold(size: 20))
                        Spacer()
                        Text("Some documents might contain signature fields. It is not required to add your signature to these fields.\n\nDigitally approving the documents will serve the same purpose as providing your signature.\n")
                            .foregroundColor(.gray)
                            .font(.openSansRegular(size: 15))
                            .multilineTextAlignment(.center)
                        genericButtonView(text: "I understand")
                            .onTapGesture {
                                didAgreeToConditions = true
                                //No need to dismiss - binding will redraw and display on parent (based on if-statement)
                            }
                        Spacer()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showPleaseTakeNoteScreen.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle(Text("Please take note"))
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct genericButtonView: View {
    var text : String
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(height: 50)
            .foregroundColor(.investDiscoveryBlue())
            .overlay(HStack {
                Text(text)
                    .foregroundColor(Color.white)
            }).padding()
    }
}
