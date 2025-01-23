//
//  Extensions.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/11.
//

import Foundation

// MARK: ===== STRING EXTENSIONS =====

internal extension String {
    var stringURL: URL? {
        let urlWithScheme = self.hasPrefix("http://") || self.hasPrefix("https://") ? self : "https://\(self)"
        
        // Attempt to create a URL from the string
        return URL(string: urlWithScheme)
    }
    
    // TODO: forecd
    var stringData: Data {
        return self.data(using: .utf8)!
    }
    
}

// MARK: ===== DATA EXTENSIONS =====

internal extension Data {
    var hexDescription: String {
        return self.map { String(format: "%02x", $0) }.joined()
    }
    
    var dataToDetailedHexString: String {
        let hexString = self.map { String(format: "0x%02X", $0) }.joined(separator: ", ")
        return hexString
    }
    
}

// MARK: ===== URL EXTENSIONS =====

internal extension URL {
    var urlData: Data {
        let urlString = self.absoluteString
        return urlString.data(using: .utf8)!
    }
    
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
