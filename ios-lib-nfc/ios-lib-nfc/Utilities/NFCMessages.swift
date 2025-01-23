//
//  NFCmessages.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/26.
//

import Foundation

internal enum NFCMessages {
    
    // MARK: common
    public static let checkRequirements = localizedString(forKey: "Check_Requirement")
    public static let nfcAlertMessage = localizedString(forKey: "NFC_AlertMessage")
    public static let nfcUnavailableTitle = localizedString(forKey: "Error_Scan_Title")
    public static let nfcUnavailableMessage = localizedString(forKey: "Error_Scan_Message")
    
    // MARK: base
    public static let viewControllerNotAvailable = localizedString(forKey: "Error_Viewcontroller")
    public static let sucessWrite = localizedString(forKey: "Sucess_Write")
    public static let errorMultipleTag = localizedString(forKey: "Error_Multiple_Tag")
    public static let errorConnect = localizedString(forKey: "Error_Connect")
    public static let errorQuery = localizedString(forKey: "Error_Query")
    public static let errorInvalidated = localizedString(forKey: "Error_Invalidated")
    public static let errorCompliant = localizedString(forKey: "Error_Compliant")
    public static let emptyMessage = localizedString(forKey: "Error_Empty_Message")
    public static let errorWriteNDEF = localizedString(forKey: "Error_NDEFwrite")
    public static let readOnly = localizedString(forKey: "Error_ReadOnly")
    public static let unknown = localizedString(forKey: "Error_Unknown")
    
    public static func scanNotAvailableWithName(_ input: String) -> String {
        return input + " is not available for scanning"
    }
    
    public static func nfcTagReaderNotDetectedWithType(_ input: String) -> String {
        return "A tag of type that is not \(input) was detected. Please try again with a \(input) tag."
    }
}

/// - Note: get string form localizable and return string
internal func localizedString(forKey key: String, _ bundle: AnyClass? = nil) -> String {
    class ThisClass {} /// bundle self
    
    let bundle =  Bundle(identifier: "ios-lib-nfc") ?? Bundle(for: type(of: ThisClass()))
    
    var result = bundle.localizedString(forKey: key, value: nil, table: nil)

    if result == key {
        result = bundle.localizedString(forKey: key, value: nil, table: "Default")
    }
    return result
}

