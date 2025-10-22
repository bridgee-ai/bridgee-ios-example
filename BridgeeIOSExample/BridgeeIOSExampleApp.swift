import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import BridgeeSDK

@main
struct BridgeeIOSExampleApp: App {
    
    init() {
        FirebaseApp.configure()
        
        // BridgeeSDK configuration
        BridgeeSDK.shared.configure(
            provider: FirebaseAnalyticsProvider(), // Using Firebase as provider
            tenantId: "tenant-id", // provided by Bridgee
            tenantKey: "tenant-key", // provided by Bridgee
            dryRun: false // true for testing, false for production
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Provider that implements AnalyticsProvider using Firebase
class FirebaseAnalyticsProvider: AnalyticsProvider {
    func setUserProperty(name: String, value: String?) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    func logEvent(name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
