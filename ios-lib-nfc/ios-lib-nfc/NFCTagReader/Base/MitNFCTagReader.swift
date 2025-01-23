//
//  MitNFCTagReader.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/13.
//

import CoreNFC
import UIKit

@available(iOS 13.0, *)
// https://qiita.com/treastrain/items/23d343d2c215ab53ecbf
open class MitNFCTagReader: NSObject, NFCTagReaderSessionDelegate{
    
    public let viewController: UIViewController?
    internal var session: NFCTagReaderSession?
    internal var isScanningEnable = true
    
    /// - Note: this class could not be created if there is no viewcontroller ->
    private override init() {
        self.viewController = nil
    }
    
    /// - Note: initilize first
    public init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    // TODO: could be match in nfc reader mode
    /// nfc reading availability
    public func checkAvailability() -> Bool {
        guard NFCTagReaderSession.readingAvailable else {
            print(NFCMessages.scanNotAvailableWithName("NFCTagReader"))
            
            if let viewController = self.viewController {
                let alertController = UIAlertController(
                    title: NFCMessages.nfcUnavailableTitle,
                    message: NFCMessages.nfcUnavailableMessage,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    viewController.present(alertController, animated: true, completion: nil)
                }
            } else {
                fatalError(NFCMessages.viewControllerNotAvailable)
            }
            return false
        }
        return true
    }
    
    // MARK: ============ NFC TAG READER DELEGATE ==================
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("scanned: " + String(isScanningEnable))
        print("tagReaderSessionDidBecomeActive(_:)")
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        
        DispatchQueue.main.async {
            self.isScanningEnable = true
        }
        
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead) && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: NFCMessages.errorInvalidated,
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.viewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        self.session = nil
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        //
        session.invalidate()
    }
}
