import SwiftUI

@main
struct MyApp: App {
    @AppStorage("nightMode") private var nightMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(nightMode ? .dark : .light)
        }
    }
}

