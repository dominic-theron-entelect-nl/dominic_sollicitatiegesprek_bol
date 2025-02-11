import SwiftUI

// MARK: - Models
struct Product: Identifiable {
    let id: UUID = UUID()
    let name: String
    let price: Double
    let image: String
    let category: String
}

// MARK: - ViewModel
class StoreViewModel: ObservableObject {
    @Published var products: [Product] = [
        Product(name: "iPhone 15 Pro", price: 999.99, image: "iphone", category: "Phones"),
        Product(name: "MacBook Pro 14", price: 1999.99, image: "macbook", category: "Laptops"),
        Product(name: "AirPods Pro", price: 249.99, image: "airpods", category: "Accessories")
    ] + (1...97).map { i in
        Product(name: "Product \(i)", price: Double.random(in: 50...2000), image: ["iphone", "macbook", "airpods"].randomElement()!, category: ["Phones", "Laptops", "Accessories"].randomElement()!)
    }
    
    @Published var cart: [Product] = []
    @Published var favorites: Set<UUID> = []
    @Published var searchText: String = ""
    
    func addToCart(_ product: Product) {
        cart.append(product)
    }
    
    func removeFromCart(_ product: Product) {
        cart.removeAll{$0.id == product.id}
    }
    
    func isCartItem(_ product: Product) -> Bool {
        return !cart.contains{$0.id == product.id}
    }
    
    func getProduct(by id: UUID) -> Product? {
        return products.first { $0.id == id }
    }
}


