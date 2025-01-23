//
//  AppRecordWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

/// - Note: structure https://appstore.com/dev/app
@available(iOS 11.0, *)
public struct AppRecordWrite: PayloadBase {
    // header for app is https://appstore.com
    private let header: Data = URIRecordType.https.uriShortcut
    private let store: Data = "appstore.com/".stringData
    
    /// - Note: ======= Requirement =======
    public var input: Any
    
    /// - Note: In the app add an input else i would fatal error
    public init(dev: String?, app: String?) {
        if let dev = dev, let app = app {
            self.input = dev + "/" + app
        } else if let dev = dev {
            self.input = dev
        } else if let app = app {
            self.input = app
        } else {
            fatalError("no input")
        }
    }
    
    public var payload: NFCNDEFPayload {
        let stringInput = input as! String
        
        let data = header + store + stringInput.stringData
        
        return NFCNDEFPayload(format: .nfcWellKnown, type: WellKnownTypeRecord.uri.uriShortcut, identifier: Data(), payload: data)
    }

}
