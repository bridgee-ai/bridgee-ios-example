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
            dryRun: true // true for testing, false for production
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum ExampleAttributionPolicy {
    static var consentGranted = false
    static var preserveNativeGoogle = false
    static var allowed: Bool { consentGranted && !preserveNativeGoogle }
}

// Provider that implements AnalyticsProvider using Firebase
@objc
class FirebaseAnalyticsProvider: NSObject, AnalyticsProvider {
    func setUserProperty(name: String, value: String?) {
        guard ExampleAttributionPolicy.allowed else { return }
        Analytics.setUserProperty(value, forName: name)
    }
    
    func logEvent(name: String, parameters: [String: Any]?) {
        guard ExampleAttributionPolicy.allowed, name != "first_open", name != "tenant_id_first_open", name != "purchase" else { return }
        Analytics.logEvent(name, parameters: parameters)
    }
}
