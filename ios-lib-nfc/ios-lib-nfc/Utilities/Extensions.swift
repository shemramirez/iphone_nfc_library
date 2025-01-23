//
//  Extensions.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation
import CoreNFC

/// string extension
public extension String {

    /// Converts the string to a URL, adding "https://" if no scheme is present.
    var stringURL: URL? {
        let urlWithScheme = self.hasPrefix("http://") || self.hasPrefix("https://") ? self : "https://\(self)"
        
        // Attempt to create a URL from the string
        return URL(string: urlWithScheme)
    }
    
    /// Converts the string to Data using UTF-8 encoding. Force-unwraps the result, assuming valid UTF-8 data.
    var stringData: Data {
        return self.data(using: .utf8)!  // TODO: Handle force unwrapping safely in production
    }
    
    var hexToString: String {
        var data = Data()
        var startIndex = self.startIndex
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: 2)
            let hexChar = String(self[startIndex..<endIndex])
            if let byte = UInt8(hexChar, radix: 16) {
                data.append(byte)
            }
            startIndex = endIndex
        }
        
        return String(data: data, encoding: .utf8)!
    }
}


/// data extension
public extension Data {

    /// Returns a string of the hex representation of the data.
    var dataToHex: String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
    
    /// Converts the data to a detailed hex string format with "0x" prefixes.
    var dataToDetailedHexString: String {
        let hexString = self.map { String(format: "0x%02X", $0) }.joined(separator: ", ")
        return hexString
    }
    
}

// url extension
internal extension URL {

    /// Converts the URL's absolute string to Data using UTF-8 encoding.
    var urlData: Data {
        let urlString = self.absoluteString
        return urlString.data(using: .utf8)!  // Force-unwrapped assuming valid UTF-8
    }
    
    /// Removes a specified substring from the URL and returns the modified URL.
    /// - Parameter string: The substring to remove from the URL.
    /// - Returns: A new URL with the substring removed, or nil if conversion fails.
    func remove(_ string: String) -> URL? {
        var urlString = self.absoluteString
        
        // Check if the URL contains the part you want to remove
        if urlString.contains(string) {
            // Remove the specified string from the URL
            urlString = urlString.replacingOccurrences(of: string, with: "")
        }
        
        // Convert the modified string back into a URL
        return URL(string: urlString)
    }
}

//
extension NFCNDEFPayload {
    var payloadToString: String {
        return ""
    }
}
