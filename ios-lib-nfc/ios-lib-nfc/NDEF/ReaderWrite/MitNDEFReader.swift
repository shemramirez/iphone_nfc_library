//
//  MitNDEFReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC

public class MitNDEFReader: MitNDEFBase {
    
    /// NDEF  session
    /// - Parameter singleTag: True = scan single tag and false for multiple tag
    public func beginReading(_ singleTag: Bool = true) {
        guard self.checkAvailability() else {
            print("===== NFC NDEF reading is not available =====")
            return
        }
        
        /// The reader session delegate object.
        /// The dispatch queue to use when calling methods on the delegate.
        /// The invalidateAfterFirstRead flag to determine whether the reader session reads only a single tag or multiple tags.
        ///
        /// To scan one time make the invalidate after first read TRUE to scan multiple make it FALSE
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: singleTag)
        self.session?.alertMessage = "Scan" // TODO: alertmessages
        self.session?.begin()
    }

    // TODO: return with message or data
}

extension MitNDEFReader {
    open override func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        //
        print(messages)
        
        let message:NFCNDEFMessage = messages[0]
        
        let record = message.records
        
        let rec = record[0]
        
        print(rec.typeNameFormat, "this is typename")
        print(rec.type, "this is type")
        let sample = rec.type
        
        print(String(data: sample, encoding: .utf8) as Any)
        print(rec.identifier, "this is identifer")
        print(String(data: rec.identifier, encoding: .utf8) as Any)
        print(rec.payload, "this is payload")
        let recpay = rec.payload
        
        // THIS GOOD
        print(recpay.dataToDetailedHexString)
        print(String(data: rec.payload, encoding: .utf8) as Any)
    }
    
}
