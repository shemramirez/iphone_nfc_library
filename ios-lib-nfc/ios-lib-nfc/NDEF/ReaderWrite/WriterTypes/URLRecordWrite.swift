//
//  URLRecordWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

/// - Note: please let them input only www.website.com in the app since the header is already set in here

/// - Note: please use NFCUtilities.isValidURL() in your app the secure the url
/// - Note: strucutre - https://www.yourinput.com
@available(iOS 11.0, *)
public struct URLRecordWrite: MitPayloadBase {
    // https://www since this is clear URL
    private let header: Data = URIRecordType.httpsWWW.uriShortcut
    
    /// - Note: ======= Requirement =======
    public var input: Any
    
    public init(_ input: URL) {
        self.input = input
    }
    
    public var payload: NFCNDEFPayload {
        guard let url = input as? URL else {
            fatalError("Invalid input type, expected URL")
        }
        
        let data = header + url.urlData
        
        return NFCNDEFPayload(format: .nfcWellKnown, type: WellKnownTypeRecord.uri.uriShortcut, identifier: Data(), payload: data)
    }
}
