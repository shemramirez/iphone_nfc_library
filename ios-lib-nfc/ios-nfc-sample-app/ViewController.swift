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
    
    var reader: MitNDEFReader!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.reader = MitNDEFReader(viewController: self)
        self.startScan(nil)
    }
    
    @IBAction func startScan(_ send: Any?) {
        self.reader.beginReading()
    }
    
    @IBAction func starWrite(_ send: Any?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController {
            navigationController?.present(vc, animated: true)
        }
        
    }
    
}
