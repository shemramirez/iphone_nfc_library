//
//  MitNDEFReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC
import SwiftUI
import Combine

public enum NFCError: Error {
    case scanNotAvailable(name: String)
    
    public var localizedDescriptionx: String {
        switch self {
        case .scanNotAvailable(let name):
            return "\(name) is not available."
        }
    }
}

@available(iOS 11.0, *)
public class MitNDEFReader: MitNDEFBase {
    
    /// Callback function returns an array of NFCNDEFMessage
    private var readHandler: ((Result<[NFCNDEFMessage], Error>) -> Void)?
    
    /// NDEF session
    /// - Parameter singleTag: True = scan single tag, false for multiple tags
    /// - Parameter readHandler: returns NFCNDEFMessage
    public func beginReading(_ singleTag: Bool = false, _ readHandler: ((Result<[NFCNDEFMessage], Error>) -> Void)? = nil) {
        
        /// - Note: This check the availablilty to scan again it needs to be true
        guard self.isScanningEnabled else {
                print("Scanning is currently disabled. Please wait.")
                return
        }
        
        self.readHandler = readHandler
        
        guard self.checkAvailability() else {
            self.readHandler?(.failure(NFCError.scanNotAvailable(name: "NDEF read")))
            
            print(NFCMessages.scanNotAvailableWithName("NDEF read"))
            return
        }
        
        self.isScanningEnabled = false
        /// The reader session delegate object.
        /// The dispatch queue to use when calling methods on the delegate.
        /// The invalidateAfterFirstRead flag to determine whether the reader session reads only a single tag or multiple tags.
        ///
        /// To scan one time make the invalidate after first read TRUE to scan multiple make it FALSE
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: singleTag)
        self.session?.alertMessage = NFCMessages.nfcAlertMessage
        self.session?.begin()
    }
}

extension MitNDEFReader {
    
    open override func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        //
        DispatchQueue.main.async {
                    // Call the readHandler with the detected messages
            self.readHandler?(.success(messages))
        }
    }
    
}
