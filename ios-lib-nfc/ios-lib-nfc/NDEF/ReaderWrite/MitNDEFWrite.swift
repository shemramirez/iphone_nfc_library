//
//  MitNDEFWrite.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC

public class MitNDEFWrite: MitNDEFBase {
    
    
    /// NDEF session and scan
    /// - Parameters:
    ///   - input: write in the ndef session - i cleared the input
    ///   - singleTag: true = scan single tag and false for multiple tag
    public func beginWriting(_ input: MitNDEFWriteTypes) {
        clearInput()
        guard self.checkAvailability() else {
            print("===== NFC NDEF writing is not available =====")
            return
        }
        // TODO: fadsf
        // check ndef and input more or somethig
        guard let payload = input._payload else {
            fatalError("cant generate payload")
        }
        
        self.message = NFCNDEFMessage(records: [payload])
        // TODO:
        /// identifiy the type of data is it by switching the payload type that is available
        ///
        
        
        /// translate the input data the type of data it is(There is two option for me to do this one is make it hex and then input to data - or let the format do its thing which is adding it into predifined typenameformat)

        ///
        /// make it into a payload
        ///
        /// then input the payload to the nfcndefmessage format
        ///
        /// input to the self.message -> and let the writing do its thing
        
        /// To scan once make the invdlaite after first read TRUE to scan multiple make it FALSE
        ///
        ///
        ///  This session must be active to write an NDEF message to the tag, so this time, invalidateAfterFirstRead is set to false, preventing the session from becoming invalid after reading the tag.
        ///  maybe invalidate lang sa detect lang
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session?.alertMessage = "Scan" // TODO: alertmessages
        self.session?.begin()
    }
      
    
    // MARK ======================================== FINAL
    /// clear input message
    private func clearInput() {
        self.message = nil
    }
    
}

extension MitNDEFWrite {
    open func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
        // the app write only to one tag - check if it only detects on tag
        if tags.count > 1 {
        // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
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
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }

            tag.queryNDEFStatus(completionHandler: { ndefStatus, capacity, error in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readWrite:
                    guard let message = self.message else {
                        session.alertMessage = "There is no alert message"
                        session.invalidate()
                        return
                    }
                    
                    tag.writeNDEF(message, completionHandler: { (error: Error?) in
                        if nil != error {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                        }
                            session.invalidate()
                    })
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            })
        })
    }
}
