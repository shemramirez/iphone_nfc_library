//
//  ViewController.swift
//  ios-nfc-sample-app
//
//  Created by ramirez on 2024/09/05.
//

import UIKit
import ios_lib_nfc

// MARK: NDEF implmentation

class ViewController: UIViewController {
    
    var reader: NDEFReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.reader = NDEFReader(viewController: self)
        // self.startScan(nil)
    }
    
    // Data = NFCNDEFMessage
    @IBAction func startScan(_ send: Any?) {
        self.reader.beginReading { ndefResults in
            
            guard let data = ndefResults else {
                 return
            }
            
            print("this is data", data)
            
        }
    }
    
    
    @IBAction func starWrite(_ send: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController {
            navigationController?.present(vc, animated: true)
        }
        
    }
    
}
