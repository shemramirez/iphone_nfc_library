//
//  URIRecord.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation

/// - Note: For well-known-type you can use RTC (Record Type Difinition) for types
internal enum WellKnownTypeRecord: UInt8 {
    /// - Note: Text Record: Contains textual data.
    case text = 0x54
        
    /// - Note: URI Record: Contains a Uniform Resource Identifier.
    case uri = 0x55
        
    /// - Note: Smart Poster Record: Combines a URI with additional metadata.
    case sp = 0x51
    
    var uriShortcut: Data {
        switch self {
        case .text:
             "T".data(using: .utf8)!
        case .uri:
             "U".data(using: .utf8)!
        case .sp:
             "Sp".data(using: .utf8)!
        }
    }
    
    var otherUriShortcut: Data {
        return Data([self.rawValue])
    }
}
