//
//  URITypeDefinition.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation

/// - Note: These are usually used in URLS or app for protocols
public enum URIRecordType: UInt8 {
    /// - Note: No specific URI scheme or type is defined. Used for records that don't fit into predefined URI schemes.
    case none = 0x00
    
    /// - Note: "http://www.". Common prefix for HTTP URIs, used for web addresses.
    case httpWWW = 0x01
    
    /// - Note: "https://www.". Indicates a secure version of HTTP, used for encrypted communication over the web.
    case httpsWWW = 0x02
    
    /// - Note:  "http://". Standard prefix for HTTP URIs, used for web addresses without the "www." prefix.
    case http = 0x03
    
    /// - Note: "https://". Used for secure HTTP URIs, similar to "https://www." but without the "www." prefix.
    case https = 0x04
    
    /// - Note:  "tel:". Used to represent telephone numbers.
    case tel = 0x05
    
    /// - Note: Represents a URI starting with "mailto:". Used to create a new email message to the specified address.
    case mailto = 0x06
    
    var uriShortcut: Data {
        return Data([self.rawValue])
    }
    
    var uriString: String {
        switch self {
        case .none:
            ""
        case .httpWWW:
            "http://www."
        case .httpsWWW:
            "https://www."
        case .http:
            "http://"
        case .https:
            "https://"
        case .tel:
            "tel:"
        case .mailto:
            "mailto:"
        }
    }
    
    static func compareTypeToURI(_ text: URL) -> URIRecordType {
        let urlString = text.absoluteString
         
        if urlString.hasPrefix(URIRecordType.httpsWWW.uriString) {
            return .httpsWWW
        } else if urlString.hasPrefix(URIRecordType.httpWWW.uriString) {
            return .httpWWW
        } else if urlString.hasPrefix(URIRecordType.https.uriString) {
            return .https
        } else if urlString.hasPrefix(URIRecordType.http.uriString) {
            return .http
        } else if urlString.hasPrefix(URIRecordType.tel.uriString) {
            return .tel
        } else if urlString.hasPrefix(URIRecordType.mailto.uriString) {
            return .mailto
        } else {
            return .none // Default to none if no match is found.
        }
    }
}
