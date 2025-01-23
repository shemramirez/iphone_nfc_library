//
//  MitNFCReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/05.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *) // reader tag is 13+ https://developer.apple.com/documentation/corenfc/nfctagreadersession
open class MitNFCReader: NSObject, NFCTagReaderSessionDelegate {
    
    public let viewController: UIViewController?
    public var session: NFCTagReaderSession?
    
    // this class could not be created if there is no viewcontroller ->
    private override init() {
        self.viewController = nil
    }
    
    // initilize first
    public init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    // TODO: could be match in nfc reader mode
    /// nfc reading availability
    public func checkAvailability() -> Bool {
        guard NFCTagReaderSession.readingAvailable else {
            print(" ===== Device is not available for scanning ===== ")
            
            if let viewController = self.viewController {
                let alertController = UIAlertController(
                    title: "Scanning not supported",
                    message: "This device dont have scanning ability",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    viewController.present(alertController, animated: true, completion: nil)
                }
            } else {
                print("===== Error =====")
            }
            return false
        }
        return true
    }
    
    // TODO: check if its open/public/private/final -> study access control
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        //
    }
    
    // TODO:
    /// NFCReaderError
    /// uiviewcontroller error
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        //
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // no writing for tagreadersessions
        session.invalidate()
    }
}
