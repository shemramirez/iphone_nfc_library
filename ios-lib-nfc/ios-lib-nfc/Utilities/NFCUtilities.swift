//
//  NFCUtilities.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/10.
//

import Foundation

internal class NFCUtilities {

    /// Checks if the given URL is valid by ensuring it has a scheme and host.
    /// - Parameter url: The URL to validate.
    /// - Returns: `true` if the URL has both a scheme and a host, otherwise `false`.
    internal func isValidURL(_ url: URL) -> Bool {
        // Validate the URL by checking for both scheme (e.g., http/https) and host (domain or IP)
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
