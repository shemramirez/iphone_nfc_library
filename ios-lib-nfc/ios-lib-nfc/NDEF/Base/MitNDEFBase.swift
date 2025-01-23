//
//  MitNDEFBase.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC

@available(iOS 11.0, *) // https://developer.apple.com/documentation/corenfc/nfcndefmessage
open class MitNDEFBase: NSObject {
    
    public let viewController: UIViewController?
    public var session: NFCNDEFReaderSession?
    
    // for writing
    internal var message: NFCNDEFMessage?
    
    // this class could not be created if there is no viewcontroller ->
    private override init() {
        self.viewController = nil
    }
    // initilaize with viewcontroller
    public init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    /// Check the device if it could scan
    /// - Returns: return true if it can false if not and present to viewcontroller
    public func checkAvailability() -> Bool {
        guard NFCNDEFReaderSession.readingAvailable else {
            print(" ===== Device is not available for scanning ===== ")
            
            if let viewController = self.viewController {
                // FIXME: imporve message
                let alertController = UIAlertController(
                    title: "===== Scanning not supported =====",
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
}

// MARK: - Delegate -

extension MitNDEFBase: NFCNDEFReaderSessionDelegate {
    open func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a
            // successful read during a single-tag read session, or because the
            // user canceled a multiple-tag read session from the UI or
            // programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.viewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        // To read new tags, a new session instance is required.
        self.session = nil
    }
    
    // TODO: ndef message details
    open func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        //
        print(messages)
    }
}
