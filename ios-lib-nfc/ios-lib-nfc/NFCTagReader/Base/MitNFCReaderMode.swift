//
//  MitNFCReaderMode.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/05.
//

import Foundation

/// reader mode enable or disable
public enum MitNFCReaderMode {
    case enableReaderMode
    case disableReaderMode
    
    public var isEnabled: Bool {
        switch self {
        case .enableReaderMode:
            return true
        case .disableReaderMode:
            return false
        }
    }
}
