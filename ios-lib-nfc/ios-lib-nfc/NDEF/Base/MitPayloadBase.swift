//
//  NDEFPayloadBase.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

/// - Note: input for the data - payload used to create payload data
@available(iOS 11.0, *)
public protocol MitPayloadBase {
    
    var input: Any { get }
    var payload: NFCNDEFPayload { get }
}
