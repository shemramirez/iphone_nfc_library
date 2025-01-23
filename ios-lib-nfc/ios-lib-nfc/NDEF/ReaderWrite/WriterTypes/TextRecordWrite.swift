//
//  TextRecordWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

// TODO: figure out the need of langauge code
/// - Note: structure - "text"
@available(iOS 11.0, *)
public struct TextRecordWrite: MitPayloadBase {
    // TODO: fix the jp data and add more language
    
    private let header: Data = Data([0x02])
    
    /// - Note: language code - en
    private let languageCode: Data = Data([0x65, 0x6E])
    
    /// - Note: ======= Requirement =======
    public let input: Any
    
    public init(_ input: String) {
        self.input = input
        
        let cod: languageCodes = .en
        cod.getLocal()
    }
    
    public var payload: NFCNDEFPayload {
        let stringInput = input as! String
        
        let data = header + languageCode + stringInput.stringData
        
        return NFCNDEFPayload(format: .nfcWellKnown, type: WellKnownTypeRecord.text.uriShortcut, identifier: Data(), payload: data)
    }
}

public enum languageCodes {
    case en
    case jp
    
    var codeData: Data {
        switch self {
        case .en:
            Data([0x65, 0x6E])
        case .jp:
            Data([0x65, 0x6E])
        }
    }
    
    func getLocal() {
        let locale = Locale.current

        print(locale.identifier)
    }
}
