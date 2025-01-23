//
//  ContentView.swift
//  NFCNDEFReaderSwiftUI
//
//  Created by ramirez on 2024/10/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ReadView()
                .tabItem {
                    Label("Read", systemImage: "qrcode.viewfinder")
                }
            
            WriteView()
                .tabItem {
                    Label("Write", systemImage: "qrcode")
                }
        }
    }
}

#Preview {
    ContentView()
}
