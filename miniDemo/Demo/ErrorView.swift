import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
            VStack {
                Image(systemName: "balloon.2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()
                
                Text("404 - Not Found")
                    .font(.title2)
                    .foregroundColor(.gray)
            }.navigationTitle("Woops").navigationBarTitleDisplayMode(.inline)
    }
}
