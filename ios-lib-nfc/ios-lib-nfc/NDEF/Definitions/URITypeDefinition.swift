//
//  URITypeDefinition.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation

// These are usually used in URLS or app for protocols
internal enum URIType: UInt8 {
    // No specific URI scheme or type is defined. Used for records that don't fit into predefined URI schemes.
    case none = 0x00
    
    // "http://www.". Common prefix for HTTP URIs, used for web addresses.
    case httpWWW = 0x01
    
    // "https://www.". Indicates a secure version of HTTP, used for encrypted communication over the web.
    case httpsWWW = 0x02
    
    //  "http://". Standard prefix for HTTP URIs, used for web addresses without the "www." prefix.
    case http = 0x03
    
    // "https://". Used for secure HTTP URIs, similar to "https://www." but without the "www." prefix.
    case https = 0x04
    
    //  "tel:". Used to represent telephone numbers.
    case tel = 0x05
    
    // Represents a URI starting with "mailto:". Used to create a new email message to the specified address.
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
    
    static func compareTypeToURI(_ text: URL) -> URIType {
        let urlString = text.absoluteString
         
        if urlString.hasPrefix(URIType.httpsWWW.uriString) {
            return .httpsWWW
        } else if urlString.hasPrefix(URIType.httpWWW.uriString) {
            return .httpWWW
        } else if urlString.hasPrefix(URIType.https.uriString) {
            return .https
        } else if urlString.hasPrefix(URIType.http.uriString) {
            return .http
        } else if urlString.hasPrefix(URIType.tel.uriString) {
            return .tel
        } else if urlString.hasPrefix(URIType.mailto.uriString) {
            return .mailto
        } else {
            return .none // Default to none if no match is found.
        }
    }
}
