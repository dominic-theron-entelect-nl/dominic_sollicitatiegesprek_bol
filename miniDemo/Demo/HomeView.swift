import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var availableFilteredProducts: [Product] {
        store.products.filter { product in !store.cart.contains(where: { $0.id == product.id }) }
    }
    
    var filteredProducts: [Product] {
        if(store.searchText.isEmpty) {
            return availableFilteredProducts
        } else {
            return availableFilteredProducts.filter{$0.name.lowercased().contains(store.searchText.lowercased())}
        }
    }

    var body: some View {
        VStack {
            AdvertBannerView()
            List(filteredProducts) { product in
                HStack {
                    Image(systemName: product.image).resizable().aspectRatio(contentMode: .fit).frame(width: 40.0, height: 40.0)
                    VStack(alignment: .leading) {
                        Text(product.name).font(.title3)
                        Text(product.price.formatted(.currency(code: "EUR"))).font(.caption)
                    }
                }.onTapGesture {
                    coordinator.navigateTo(.productDetail(product.id))
                }
            }.searchable(text: $store.searchText, prompt: "Search Products")
        }.navigationTitle("Home").toolbar {
            CartToolbarItem()
        }
    }
}

// MARK: - Scrolling Advert Banner
struct AdvertBannerView: View {
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    @State private var isExpanded: Bool = true
    
    var availableProducts: [Product] {
        store.products.filter { product in !store.cart.contains(where: { $0.id == product.id }) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Featured Products")
                    .font(.headline)
                Spacer()
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding()
                }
            }
            .padding(.horizontal, 16)
            
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(availableProducts.prefix(5)) { product in
                            VStack {
                                Image(systemName: product.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .padding()
                                
                                Text(product.name)
                                    .font(.headline)
                                
                                Text("$\(product.price, specifier: "%.2f")")
                                    .foregroundColor(.green)
                                
                                Button(action: {
                                    store.addToCart(product)
                                }) {
                                    Text("Add to Cart")
                                        .frame(maxWidth: .infinity)
                                        .padding(5)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                            .frame(width: 180)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}


// MARK: - Cart Badge Toolbar Item
struct CartToolbarItem: View {
    @EnvironmentObject var store: StoreViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var cartCount: Int {
        store.cart.count
    }
    
    var body: some View {
        ZStack {
            Button(action: {
                coordinator.navigateTo(.cart)
            }) {
                Image(systemName: "cart")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            if cartCount > 0 {
                Text("\(cartCount)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 15, y: -10)
                    .animation(.easeInOut, value: cartCount)
            }
        }
    }
}
