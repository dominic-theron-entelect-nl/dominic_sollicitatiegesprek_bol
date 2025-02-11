import SwiftUI

struct GenericOptionButtonView: View {
    @Binding var text: String?
    @Binding var value: String?
    @Binding var selectedOption: String
    
    var body: some View {
        Button(action: {
            selectedOption = value ?? ""
        }) {
            HStack {
                Text(text ?? "")
                    .foregroundColor(.black)
                    .font(.body)
                Spacer()
                if (selectedOption == value){
                    Image("checkmark", bundle: .investResources())
                       .frame(width: 30,height: 30)
                }
            }
        }.listRowBackground(Color.white)
    }
}
