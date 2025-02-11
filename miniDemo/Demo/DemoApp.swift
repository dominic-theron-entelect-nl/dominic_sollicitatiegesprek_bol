import SwiftUI

@main
struct DemoApp: App {
    @StateObject var store = StoreViewModel()
    @StateObject var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(store)
                .environmentObject(coordinator)
                .onOpenURL { url in
                    coordinator.handleDeepLink(url: url)
                }
        }
    }
}
