import SwiftUI

// MARK: - Product Detail View
struct ProductDetailView: View {
    let productId: UUID
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        if let product = store.getProduct(by: productId) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack{
                        Spacer()
                        Image(systemName: product.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .padding(.top, 20)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("€\(product.price, specifier: "%.2f")")
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding(.horizontal, 16)
                        Text("Category: \(product.category)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                        CopyToClipboardButton(textToCopy: "DemoApp://product?id=" + product.id.uuidString)
                    }
                    
                    
                    HStack(spacing: 20) {
                        
                        if(store.isCartItem(product)) {
                            Button(action: {
                                store.addToCart(product)
                            }) {
                                Text("Add to Cart")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            Button(action: {
                                store.removeFromCart(product)
                            }) {
                                Text("Remove from Cart")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }
            .navigationTitle(product.name).navigationBarTitleDisplayMode(.inline).toolbar {
                CartToolbarItem()
            }
        } else {
            VStack {
                Text("Product not found")
            }
        }
    }
}

// MARK: - Copy to Clipboard Button
struct CopyToClipboardButton: View {
    let textToCopy: String
    @State private var copied = false
    
    var body: some View {
        VStack {
            Button(action: {
                UIPasteboard.general.string = textToCopy
                copied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    copied = false
                }
            }) {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy UUID to Clipboard")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if copied {
                Text("Copied to clipboard!")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .transition(.opacity)
            }
        }
        .padding()
    }
}
