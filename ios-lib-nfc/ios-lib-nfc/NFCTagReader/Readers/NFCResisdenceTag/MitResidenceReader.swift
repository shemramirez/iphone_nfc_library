//
//  MitResidenceReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/19.
//

import Foundation
import CoreNFC

// TODO: store datas and display
public class MitResidenceReader: MitNFCTagReader {
    public func beginScanning() {
        guard self.isScanningEnable else {
                print("Scanning is currently disabled. Please wait.")
                return
        }
        
        guard self.checkAvailability() else {
            print(NFCMessages.scanNotAvailableWithName("Residence Tag"))
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
            
            guard case NFCTag.iso7816(let residenceTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = NFCMessages.nfcTagReaderNotDetectedWithType("Residence Tag")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            
            switch residenceTag.initialSelectedAID {
            case ResidenceTag.AID.D392F02, 
                ResidenceTag.AID.D392F03,
                ResidenceTag.AID.D392F04:
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
            print(residenceTag)      
            
            session.alertMessage = "Read success!\nMy number card: \(residenceTag)"
            session.invalidate()
        }
    }
}
