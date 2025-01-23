//
//  MitNFCReaderDelegate.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/05.
//

import Foundation

/// always make a function that would invalidate
protocol MitNFCReaderDelegate {
    func mitNFCReaderSession(didInvalidateWithError error: Error)
}
