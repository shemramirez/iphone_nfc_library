//
//  WriteView.swift
//  NFCNDEFReaderSwiftUI
//
//  Created by ramirez on 2024/10/10.
//

import SwiftUI
import ios_lib_nfc

enum WriteTypes: String, CaseIterable {
    case text = "Text"
    case url = "URL"
    case uri = "URI"
    case app = "App"
}

struct WriteView: View {
    
    @StateObject private var session = NDEFWrite(viewController: nil)
    @State var input: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("Enter text", text: $input)
                    .frame(width: 230,height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                VStack {
                    Button{
                        self.session.beginWriting(TextRecordWrite("text"))
                    } label: {
                        Image(systemName: "qrcode")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                
                HStack {
                    ForEach(WriteTypes.allCases, id: \.self) { writeType in
                        Button(writeType.rawValue) {
                            // Handle button actions for each writeType
                            print("Selected: \(writeType.rawValue)")
                            switch writeType {
                            case .text:
                                self.session.beginWriting(TextRecordWrite(input))
                            case .url:
                                let sampleText = input
                                guard let url = URL(string: sampleText) else {
                                    // Handle invalid URL
                                    print("Invalid URL")
                                    return
                                }
                                self.session.beginWriting(URLRecordWrite(url))
                            case .uri:
                                let sampleText = input
                                guard let url = URL(string: sampleText) else {
                                    // Handle invalid URL
                                    print("Invalid URL")
                                    return
                                }
                                self.session.beginWriting(URIRecordWrite(url))
                            case .app:
                                self.session.beginWriting(AppRecordWrite(dev: input, app: nil))
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Write")
        }
    }
}

#Preview {
    WriteView()
}
