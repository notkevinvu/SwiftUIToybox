//
//  LANConnectionTestView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 12/16/24.
//

import SwiftUI

struct LANConnectionTestView: View {
    
    /// Kevin's work MBP ip address = 10.0.6.11
    @State var ipAddress: String = "10.0.6.11"
    @State var port: String = "8000"
    @State var didAttemptFirstPing: Bool = false
    @State var didSucceedMostRecentPing: Bool = false
    @State var responseMessage: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            LabeledContent {
                TextField("Port", text: $port)
                    .textFieldStyle(.roundedBorder)
            } label: {
                Text("Port number")
            }
            
            LabeledContent {
                TextField("Target LAN IP address", text: $ipAddress)
                    .textFieldStyle(.roundedBorder)
            } label: {
                Text("IP Address")
            }
            
            Button {
                Task {
                    await pingLANConnection()
                }
            } label: {
                Text("Test LAN connection")
            }
            .buttonStyle(.borderedProminent)
            
            if didAttemptFirstPing {
                Label(
                    didSucceedMostRecentPing ? "Success" : "Failure",
                    systemImage: didSucceedMostRecentPing ? "checkmark.seal.fill" : "xmark.seal.fill"
                )
                .foregroundStyle(didSucceedMostRecentPing ? .green : .red)
            }
            
            Spacer()
            
            VStack {
                Text("Response message:")
                Text(responseMessage)
            }
            
        }
        .padding()
    }
    
    // MARK: -- Methods
    
    private func formatRequestAddress() -> URL? {
        guard !ipAddress.isEmpty,
              !port.isEmpty,
              let portInt = Int(port)
        else {
            DebugLog.line("\(String(describing: type(of: self))).\(#function) - No port or ip address")/
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = ipAddress
        urlComponents.port = portInt
        
        guard let fullUrl = urlComponents.url else {
            DebugLog.line("\(String(describing: type(of: self))).\(#function) - Failed to create URL from components: \(urlComponents)")/
            return nil
        }
        
        return fullUrl
    }
    
    private func pingLANConnection() async {
        didAttemptFirstPing = true
        DebugLog.line("\(String(describing: type(of: self))).\(#function) - Attempting to ping lan connection")/
        guard let url = formatRequestAddress() else {
            DebugLog.line("\(String(describing: type(of: self))).\(#function) - Failed to get request address")/
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            DebugLog.line("\(String(describing: type(of: self))).\(#function) - Successfully pinged lan connection with data: \(data) and response: \(response)")/
            responseMessage = response.description
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                didSucceedMostRecentPing = true
            } else {
                didSucceedMostRecentPing = false
            }
        } catch let error {
            DebugLog.errorWithDesc("\(String(describing: type(of: self))):\(#function) - Failed to ping lan connection", error)/
        }
    }
}

#Preview {
    LANConnectionTestView()
}
 
