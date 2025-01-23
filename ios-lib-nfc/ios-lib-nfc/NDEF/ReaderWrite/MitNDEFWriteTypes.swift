//
//  NDEFWriteTypes.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/09/12.
//

import Foundation
import CoreNFC

// TODO: This gets and create the payload
public struct MitNDEFWriteTypes {
    
    var payloadType: MitNDEFType?
    // TODO: add more values
    
    // used for sending string type or characters
    private let text: String?
    // used for sending urls
    private let url: URL?
    // custom uri or urls you want
    private let uri: URL?
    
    private mutating func configurePayload() {
        switch payloadType {
        case .text:
            if let text = text, !text.isEmpty {
                // if old

                // THIS will have no protocol
                //self._payload = NFCNDEFPayload(format: NFCTypeFormat.nfcWellKnown, type: URIRecord.text.uriShortcut, identifier: Data(), payload: text.stringData)
                
            
                // first data is status 0x02 + language + string data
                let data = Data([URIType.httpsWWW.rawValue]) + Data([0x65, 0x6E]) + text.stringData
                
                // https://qiita.com/shimosyan/items/ed21fb6984240baa7397
                // based here there
                    
                // format -> wellknown
                // type -> text type
                // idenfiier -> no idenfier
                // payload
                // create payload
                self._payload = NFCNDEFPayload(format: .nfcWellKnown, type: URIRecord.text.uriShortcut, identifier: Data(), payload:data)
            }
        case .url:
            if let url = url, !url.absoluteString.isEmpty {
                // TODO: could be better
                self._payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
            }
        case .customURL:
            if let uri = uri, !uri.absoluteString.isEmpty {
                // Handle case where neither text nor URL is provided
                
                // find for the type
                let uriType = URIType.compareTypeToURI(uri)
                
                // format -> wellknown
                // type -> U data -> 0x55
                // identifier -> check first doesnt do this
                // data
                
                let cleanData = uri.remove(uriType.uriString)
                
                if let cleaned = cleanData {
                    self._payload = NFCNDEFPayload.init(format: .nfcWellKnown, type: URIRecord.uri.uriShortcut, identifier: Data(), payload: uriType.uriShortcut + cleaned.urlData)
                }
            }
        case nil:
            self._payload = nil
            fatalError(" there is no payload")
        }
    }
    
    // MARK: GET NFCNDEF PAYLOAD -> the payload is not used
    internal var _payload: NFCNDEFPayload?
    // MARK: ================ DATA INITIALIZATION =======================
    
    // Public initializer for text
    public init(text: String) {
        self.text = text
        self.url = nil
        self.uri = nil
        self.payloadType = .text
        configurePayload()
    }
    
    public init(url: URL) {
        guard NFCUtilities().isValidURL(url) else {
            fatalError("Invalid URL provided")
        }
        self.text = nil
        self.url = url
        self.uri = nil
        self.payloadType = .url
        configurePayload()
    }
        
    public init(uri: URL) {
        self.text = nil
        self.url = nil
        self.uri = uri
        self.payloadType = .customURL
        configurePayload()
    }
}


