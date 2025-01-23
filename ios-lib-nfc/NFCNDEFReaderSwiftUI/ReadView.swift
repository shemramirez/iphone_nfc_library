//
//  ReadView.swift
//  NFCNDEFReaderSwiftUI
//
//  Created by ramirez on 2024/10/10.
//

import SwiftUI
import ios_lib_nfc
import CoreNFC

struct ReadView: View {
    
    @StateObject private var session = MitNDEFReader(viewController: nil)
    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    @State private var ndefMessage: [NFCNDEFMessage]?
    
    var body: some View {
        NavigationView {
            VStack {
                Button{
                    self.session.beginReading { result in
                        
                        switch result {
                        case .success(let nfcmessage):
                            self.ndefMessage = nfcmessage
                        case .failure(let error as NFCError):
                            alertMessage = error.localizedDescriptionx
                            showAlert = true
                        case .failure(_):
                            print("error")
                        }
                    }
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
                        }
                .buttonStyle(.bordered)
                NavigationLink(destination: ResultView(data: ndefMessage), isActive: .constant(ndefMessage != nil)) {
                        EmptyView()
                }
            }
            .navigationTitle("Reader")
        }
    }
    
}

#Preview {
    ReadView()
}
