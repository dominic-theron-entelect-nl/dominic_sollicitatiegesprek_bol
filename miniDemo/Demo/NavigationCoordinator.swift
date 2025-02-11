import SwiftUI

enum AppRoute: Hashable {
    case home
    case productDetail(UUID)
    case cart
    case error
    
    static func from(url: URL) -> AppRoute? {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            guard let host = components?.host else { return nil }
            
            switch host {
            case "home":
                return .home
            case "product":
                if let queryItems = components?.queryItems,
                   let idString = queryItems.first(where: { $0.name == "id" })?.value,
                   let uuid = UUID(uuidString: idString) {
                    return .productDetail(uuid)
                }
            case "cart":
                return .cart
            default:
                return .error
            }
            return nil
        }
}


class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateTo(_ route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func resetNavigation() {
        path = NavigationPath()
    }
    
    func handleDeepLink(url: URL) {
            if let route = AppRoute.from(url: url) {
                DispatchQueue.main.async {
                    self.navigateTo(route)
                }
            }
        }
}


struct AppNavigationView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                    case .productDetail(let id):
                        ProductDetailView(productId: id)
                    case .cart:
                        ShoppingCartView()
                    case .error:
                        ErrorView()
                    }
                }
        }
    }
}
