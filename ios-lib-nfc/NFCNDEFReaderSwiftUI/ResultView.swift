//
//  ResultView.swift
//  NFCNDEFReaderSwiftUI
//
//  Created by ramirez on 2024/10/10.
//

import SwiftUI
import CoreNFC

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    var data: [NFCNDEFMessage]?

    var body: some View {
        VStack {
            Button("Dismiss") {
                dismiss()
            }
            .padding()

            List {
                // Displaying each NFCNDEFMessage
                Section(header: Text("NFC NDEF Message Details")) {
                    if let ndefMessages = data, !ndefMessages.isEmpty {
                        ForEach(ndefMessages, id: \.self) { message in
                            ForEach(message.records, id: \.self) { record in
                                VStack(alignment: .leading) {
                                    // Convert payload to string and hex
                                    let payloadData = record.payload
                                    let hexString = payloadData.dataToHex
                                    let text = hexString.hexToString

                                    Text("Payload: \(String(data: payloadData, encoding: .utf8) ?? "N/A")")
                                    Text("Hex: \(hexString)")
                                    Text("Text: \(text)")
                                }
                                .padding()
                            }
                        }
                    } else {
                        Text("No NFC NDEF Message data available.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("NFC Data")
    }
}

#Preview {
    ResultView(data: nil) // Use a valid instance of NFCNDEFMessage for testing
}
