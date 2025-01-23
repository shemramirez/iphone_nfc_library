//
//  MyNumberReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

// TODO: store data and display
// iso14431 - iso7816
public class MyNumberReader: NFCTagReader {
    public func beginScanning() {
        guard self.isScanningEnable else {
                print("Scanning is currently disabled. Please wait.")
                return
        }
        guard self.checkAvailability() else {
            print(NFCMessages.scanNotAvailableWithName("MyNumber Tag"))
            return
        }
        self.isScanningEnable = false
        
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = NFCMessages.nfcAlertMessage
        self.session?.begin()
    }
    
    open override func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = NFCMessages.errorMultipleTag
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        let tag = tags.first!
        
        session.connect(to: tag) { (error) in
            if nil != error {
                session.invalidate(errorMessage: NFCMessages.errorConnect)
                return
            }
            
            guard case NFCTag.iso7816(let myNumberCardTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = NFCMessages.nfcTagReaderNotDetectedWithType("MyNumber Tag")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            
            switch myNumberCardTag.initialSelectedAID {
            case "D392F000260100000001", "D3921000310001010408", "D3921000310001010100", "D3921000310001010401":
                break
            default:
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = "No mynumber card"
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            print(myNumberCardTag)
            
            session.alertMessage = "Read success!\nMy number card: \(myNumberCardTag)"
            session.invalidate()
        }
    }
}
