//
//  TypeNameFormats.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/10/03.
//

import Foundation
import CoreNFC

// this is alternative
typealias TNF = NFCTypeNameFormat

/// Enum representing different NFC Type Name Formats.
@available(iOS 11.0, *)
public enum TypeNameFormats: UInt8 {
    /// Empty format, no type information.
    case empty = 0x00
    
    /// NFC Forum well-known type (NFC RTD).
    case wellKnown = 0x01
    
    /// Media-type as defined in RFC2046.
    case mediaType = 0x02
    
    /// Absolute URI as defined in RFC3986.
    case absoluteURI = 0x03
    
    /// NFC Forum external type.
    case externalType = 0x04
    
    /// Unknown type format.
    case unknown = 0x05
    
    /// Unchanged type format, used for unchanged messages in a chaining message.
    case unchanged = 0x06
    
    /// Reserved for future use.
    case reserved = 0x07
}
