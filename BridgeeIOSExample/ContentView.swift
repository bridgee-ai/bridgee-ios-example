import SwiftUI
import FirebaseAnalytics
import BridgeeSDK

struct ContentView: View {
    @State private var consentGranted = false
    @State private var nativeGoogle = false
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var showMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Bridgee iOS SDK")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("First Open Simulator")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Form Container
            VStack(spacing: 20) {
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .font(.body)
                }
                
                // Phone Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your phone", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .font(.body)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
            
            Toggle("Permitir atribuição neste teste", isOn: $consentGranted)
                .onChange(of: consentGranted) { ExampleAttributionPolicy.consentGranted = $0 }
            Toggle("Preservar atribuição nativa Google", isOn: $nativeGoogle)
                .onChange(of: nativeGoogle) { ExampleAttributionPolicy.preserveNativeGoogle = $0 }
            Text("Dry run. Firebase controla first_open; consulta não confirma instalação.")
                .font(.footnote)
            // Send Button
            Button(action: {
                sendCustomFirstOpenEvent()
            }) {
                Text("Consultar atribuição")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .disabled(!consentGranted || nativeGoogle)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .alert(isPresented: $showMessage) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    
    private func sendCustomFirstOpenEvent() {
        guard ExampleAttributionPolicy.allowed else { return }
        // Create the MatchBundle with user data
        let matchBundle = MatchBundle()
        
        if !name.isEmpty {
            matchBundle.set(name: name)
        }
        
        if !email.isEmpty {
            matchBundle.set(email: email)
        }
        
        if !phone.isEmpty {
            matchBundle.set(phone: phone)
        }
        
        // Call BridgeeSDK firstOpen with the MatchBundle
        BridgeeSDK.shared.firstOpen(with: matchBundle) { utmData, error in
            DispatchQueue.main.async {
                if let utmData = utmData {
                    // Success - show UTMs
                    self.alertTitle = "✅ Success!"
                    self.alertMessage = self.formatSuccessMessage(utmData: utmData)
                    print("🌉 BridgeeSDK firstOpen completed successfully")
                    print("📊 UTM Source: \(utmData.utm_source)")
                    print("📊 UTM Medium: \(utmData.utm_medium)")
                    print("📊 UTM Campaign: \(utmData.utm_campaign)")
                } else {
                    // Error - show error message
                    self.alertTitle = "❌ Error"
                    self.alertMessage = error ?? "First Open without Match - No UTM Data"
                    print("❌ BridgeeSDK firstOpen failed: \(error ?? "Unknown error")")
                }
                self.showMessage = true
            }
        }
        
        print("🌉 BridgeeSDK firstOpen called")

    }
    
    private func formatSuccessMessage(utmData: UTMData) -> String {
        var message = "UTM data:\n\n"
        
        message += "UTM Source: \(utmData.utm_source)\n"
        message += "UTM Medium: \(utmData.utm_medium)\n"
        message += "UTM Campaign: \(utmData.utm_campaign)"
        
        return message
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
