//
//  FeliCaReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/12.
//

import Foundation
import CoreNFC

// iso18092
// sample felica works
public class FeliCaReader: NFCTagReader {
    
    private var readHandler: ((NFCFeliCaTag?) -> Void)?

    public func beginScanning(_ readHandler: ((NFCFeliCaTag?) -> Void)? = nil) {
        
        guard self.isScanningEnable else {
                print("Scanning is currently disabled. Please wait.")
                return
        }
        
        self.readHandler = readHandler
        
        guard self.checkAvailability() else {
            print(NFCMessages.scanNotAvailableWithName("FeliCa Tag"))
            return
        }
        
        self.isScanningEnable = false
    
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
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
            
            guard case .feliCa(let feliCaTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(500)
                session.alertMessage = NFCMessages.nfcTagReaderNotDetectedWithType("Felica")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                })
                return
            }
            
            self.readHandler?(feliCaTag)
            
            let idm = feliCaTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
            let systemCode = feliCaTag.currentSystemCode.map { String(format: "%.2hhx", $0) }.joined()
            
            print("IDm: \(idm)")
            print("System Code: \(systemCode)")
            
            session.alertMessage = "Read success!\nIDm: \(idm)\nSystem Code: \(systemCode)"
            session.invalidate()
        }
    }
}
