//
//  NDEFBase.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/06.
//

import UIKit
import CoreNFC
import SwiftUI
import Combine

/// https://developer.apple.com/documentation/corenfc/nfcndefmessage
@available(iOS 11.0, *)
open class NDEFBase: NSObject, ObservableObject{
    
    public let viewController: UIViewController?
    public var session: NFCNDEFReaderSession?
    internal var message: NFCNDEFMessage?
    internal var isScanningEnabled = true
    
    /// - Note: This initializer cannot be used if a view controller is not provided.
    private override init() {
        self.viewController = nil
    }
    
    /// - Note: Initializes a new instance of the class.
    public init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    /// Check the device if it could scan
    /// - Returns: return true if it can false if not and present to viewcontroller
    public func checkAvailability() -> Bool {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("""
                    ===========================================================================
                    NFC is not available. Please check the requirements in the readme section.
                    ===========================================================================
                    """)
        
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
                // there is no viewcontroller or its swiftui
                print(NFCMessages.viewControllerNotAvailable)
            }
            return false
        }
        return true
    }
}

// MARK: - Delegate -

extension NDEFBase: NFCNDEFReaderSessionDelegate {
    /// Called when the reader session is invalidated due to an error.
    /// - Parameters:
    ///   - session: The NFCNDEFReaderSession that was invalidated.
    ///   - error: The error that caused the session to become invalidated.
    open func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        
        /// - Note: This needs to be done first so that it is invalidated after you scan again
        self.isScanningEnabled = true
        print("Scanning is enabled again.")
        
        /// Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            /// Show an alert when the invalidation reason is not because of a
            /// successful read during a single-tag read session, or because the
            /// user canceled a multiple-tag read session from the UI or
            /// programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: NFCMessages.errorInvalidated,
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.viewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        /// To read new tags, a new session instance is required.
        self.session = nil
    }
    
    /// Called when the reader session detects NDEF messages.
    /// - Parameters:
    ///   - session: The NFCNDEFReaderSession that detected the NDEF messages.
    ///   - messages: An array of NFCNDEFMessage objects detected by the session.
    open func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print(messages)
    }
    
    
    open func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print(session)
    }
}
