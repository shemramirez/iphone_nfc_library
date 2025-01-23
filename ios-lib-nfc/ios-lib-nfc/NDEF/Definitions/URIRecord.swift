//
//  URIRecord.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation

internal enum URIRecord: UInt8 {
    // Text Record: Contains textual data.
    case text = 0x54
        
    // URI Record: Contains a Uniform Resource Identifier.
    case uri = 0x55
        
    // Smart Poster Record: Combines a URI with additional metadata.
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
