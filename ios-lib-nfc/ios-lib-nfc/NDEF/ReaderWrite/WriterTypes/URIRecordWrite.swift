//
//  URIRecordWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

/// - Note: structure - "www.input.com"
@available(iOS 11.0, *)
public struct URIRecordWrite: PayloadBase {
    /// - Note: header = would depend on what is the uri type
    private let header: Data
    
    public enum types: String {
        case none = ""
        case httpWWW = "http://www."
        case httpsWWW = "https://www."
        case http = "http://"
        case https = "https://"
        case tel = "tel:"
        case mailto = "mailto:"
    }
    
    /// - Note: ======= Requirement =======
    public var input: Any
    
    public init(_ input: URL) {
        self.input = input
        
        self.header = URIRecordType.compareTypeToURI(input).uriShortcut
    }
    
    public var payload: NFCNDEFPayload {
        guard let url = input as? URL else {
            fatalError("Invalid input type, expected URI")
        }
        
        let data = header + url.urlData
        
        return NFCNDEFPayload(format: .nfcWellKnown, type: WellKnownTypeRecord.uri.uriShortcut, identifier: Data(), payload: data)
    }
}
