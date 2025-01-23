//
//  WriteViewController.swift
//  ios-nfc-sample-app
//
//  Created by ramirez on 2024/09/11.
//

import UIKit
import ios_lib_nfc

class WriteViewController: UIViewController {

    var writer: MitNDEFWrite!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writer = MitNDEFWrite(viewController: self)
    }
    
    let sampleText = "en98,2"
    
    @IBAction func writeText(_ sender: Any) {
        self.writer.beginWriting(MitNDEFWriteTypes.init(text: sampleText))
    }
    
    let urlString = URL(string: "https^://www.google.com")
    
    @IBAction func writeURL(_ sender: Any) {
        guard let url = urlString else {
            return
        }
        self.writer.beginWriting(MitNDEFWriteTypes.init(url: url))
    }
    @IBAction func writeURI(_ sender: Any) {
        guard let url = urlString else {
            return
        }
        self.writer.beginWriting(MitNDEFWriteTypes.init(uri: url))
    }
}
