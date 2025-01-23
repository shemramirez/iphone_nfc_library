//
//  NFCUtilities.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/10.
//

import Foundation
import CoreNFC


internal class NFCUtilities {
    // this is to check if the url is valid
    internal func isValidURL(_ url: URL) -> Bool {
        // Implement URL validation logic if needed
        return url.scheme != nil && url.host != nil
    }
}


// ============== MARK: studiyng materials  ===============

// https://engineering.purdue.edu/ece477/Archive/2012/Spring/S12-Grp14/Specs/NFC/NFCRTD.pdf

// https://developer.apple.com/documentation/corenfc/nfcndefpayload?language=objc

//TODO: show all the possible results -> possibly make a viewcontroller that shows all records
///     maybe make this as a STRUCT
///     enum ndefResults {
///         case tnf // "TNF=1
///         case payloadType //Payload Type={length = 1, bytes = 0x54}
///         case payloadID // Payload ID={length = 0, bytes = 0x}
///         case payload // Payload={length = 7, bytes = 0x02656e39382c32}
///         case chunksize // ChunkSize=4294967295"
///       }

//    0x02: This could be a control byte or identifier. Its meaning depends on the context in which it is used.
//    0x67: Represents the ASCII character g.
//    0x6F: Represents the ASCII character o.
//    0x6F: Represents the ASCII character o.
//    0x67: Represents the ASCII character g.
//    0x6C: Represents the ASCII character l.
//    0x65: Represents the ASCII character e.
//    0x2E: Represents the ASCII character . (period).
//    0x63: Represents the ASCII character c.
//    0x6F: Represents the ASCII character o.
//    0x6D: Represents the ASCII character m.

