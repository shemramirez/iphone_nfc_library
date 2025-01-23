//
//  NDEFWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC

@available(iOS 11.0, *)
public class NDEFWrite: NDEFBase {
    
    /// NDEF session and scan
    /// - Parameters:
    ///   - input: write in the ndef session - i cleared the input
    ///   - singleTag: true = scan single tag and false for multiple tag
    public func beginWriting(_ input: PayloadBase) {
        /// - Note: This check the availablilty to scan again it needs to be true
        guard self.isScanningEnabled else {
                print("Scanning is currently disabled. Please wait.")
                return
        }

        clearInput()
        
        guard self.checkAvailability() else {
            print(NFCMessages.scanNotAvailableWithName("NDEF write"))
            return
        }
        
        self.isScanningEnabled = false
        ///- Note: you can write multiple but scan once
        
        // the input data
        self.message = NFCNDEFMessage(records: [input.payload])
        /// - Note: To scan once make the invdlaite after first read TRUE to scan multiple make it FALSE
        ///
        ///
        ///  This session must be active to write an NDEF message to the tag, so this time, invalidateAfterFirstRead is set to false, preventing the session from becoming invalid after reading the tag.
        ///  maybe invalidate lang sa detect lang
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session?.alertMessage = NFCMessages.nfcAlertMessage
        self.session?.begin()
    }
    
    /// clear input message
    private func clearInput() {
        self.message = nil
    }
    
}

extension NDEFWrite {
    open func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
        // the app write only to one tag - check if it only detects on tag
        if tags.count > 1 {
        // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = NFCMessages.errorMultipleTag
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
            session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { error in
            // this means if an error occurs -> send alert message and invalidate
            if nil != error {
                session.alertMessage = NFCMessages.errorConnect
                session.invalidate()
                return
            }

            tag.queryNDEFStatus(completionHandler: { ndefStatus, capacity, error in
                guard error == nil else {
                    session.alertMessage = NFCMessages.errorQuery
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = NFCMessages.errorCompliant
                    session.invalidate()
                case .readWrite:
                    // TODO: decide the the requirement needs to be empty or not empty
                    guard let message = self.message else {
                        session.alertMessage = NFCMessages.emptyMessage
                        session.invalidate()
                        return
                    }
                    
                    tag.writeNDEF(message, completionHandler: { (error: Error?) in
                        if nil != error {
                            session.alertMessage = NFCMessages.errorWriteNDEF + "\(error!)"
                        } else {
                            session.alertMessage = NFCMessages.sucessWrite
                        }
                            session.invalidate()
                    })
                case .readOnly:
                    session.alertMessage = NFCMessages.readOnly
                    session.invalidate()
                @unknown default:
                    session.alertMessage = NFCMessages.unknown
                    session.invalidate()
                }
            })
        })
    }
    open override func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Currently active")
    }
}
