import SwiftUI

// MARK: - Shopping Cart View
struct ShoppingCartView: View {
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var totalPrice: Double {
        store.cart.reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        VStack {
            if store.cart.isEmpty {
                VStack {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("Your cart is empty")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            } else {
                List(store.cart) { product in
                        HStack {
                            Image(systemName: product.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding()
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.headline)
                                Text("$\(product.price, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                    }.onTapGesture {
                        coordinator.navigateTo(.productDetail(product.id))
                    }.swipeActions {
                        Button(role: .destructive) {
                            store.removeFromCart(product)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }

                    }
                }
                .listStyle(PlainListStyle())
                
                VStack {
                    Text("Total: €\(totalPrice, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Button(action: {
                        // Simulate order action
                        store.cart.removeAll()
                        coordinator.resetNavigation()
                    }) {
                        Text("Order Now")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 20)
            }
        }.navigationTitle("Shopping Cart").navigationBarTitleDisplayMode(.inline)
    }
}
