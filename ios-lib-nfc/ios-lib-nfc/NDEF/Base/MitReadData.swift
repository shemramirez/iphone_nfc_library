//
//  MitReadData.swift
//  ios-lib-nfc
//
//  Created by ramirez on 2024/10/03.
//

import Foundation

public struct MitReadData {
    let typeNameFormat: TypeNameFormats
    let payloadType: WellKnownTypeRecord
    let payloadID: Data
    let payload: Payload
    let chunkSize: Data

    init(typeNameFormat: TypeNameFormats, payloadType: WellKnownTypeRecord, payloadID: Data, payload: Payload, chunkSize: Data) {
        self.typeNameFormat = typeNameFormat
        self.payloadType = payloadType
        self.payloadID = payloadID
        self.payload = payload
        self.chunkSize = chunkSize
    }
}

public struct Payload {
    let header: String
    let payloadText: String
}
