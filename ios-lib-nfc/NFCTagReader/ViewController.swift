//
//  ViewController.swift
//  ios-nfc-sample-app
//
//  Created by ramirez on 2024/09/05.
//

import UIKit
import ios_lib_nfc
import CoreNFC

// MARK: NDEF implmentation

class ViewController: UIViewController {

    var mitReader: MitMyNumberReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startScan(_ send: Any?) {
        self.mitReader = MitMyNumberReader(viewController: self)
        
        // incase if there as any display delay
        DispatchQueue.main.async {
            self.mitReader.beginScanning()
//            { data in
//                let input = data
//                
//                let idm = input?.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
//                let systemCode = input?.currentSystemCode.map { String(format: "%.2hhx", $0) }.joined()
//                
//                print("IDm: \(idm!)")
//                print("System Code: \(systemCode!)")
//                
//            }
        }
    }
}
extension NFCFeliCaTag {
    public func polling(systemCode: Data, requestCode: NFCFeliCaPollingRequestCode, timeSlot: NFCFeliCaPollingTimeSlot) -> (pmm: Data, systemCode: Data, error: Error?) {
        var resultPMm: Data!
        var resultSystemCode: Data!
        var resultError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.polling(systemCode: systemCode, requestCode: requestCode, timeSlot: timeSlot) { (pmm, systemCode, error) in
            resultPMm = pmm
            resultSystemCode = systemCode
            resultError = error
            semaphore.signal()
        }
        semaphore.wait()
        return (resultPMm, resultSystemCode, resultError)
    }
}
