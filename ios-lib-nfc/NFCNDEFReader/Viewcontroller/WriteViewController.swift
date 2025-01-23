//
//  WriteViewController.swift
//  ios-nfc-sample-app
//
//  Created by ramirez on 2024/09/11.
//

import UIKit
import ios_lib_nfc

enum WriteType {
    case text
    case url
    case uri
    case app
}

class WriteViewController: TextFieldViewController {

    var writer: MitNDEFWrite!
    var type: MitPayloadBase?
    var selectedButton: WriteType = .text

    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var uriButton: UIButton!
    @IBOutlet weak var appButton: UIButton!
    @IBOutlet weak var uriLabels: UIButton!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var textDevInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize
        textInput.delegate = self
        textDevInput.delegate = self
        self.writer = MitNDEFWrite(viewController: self)
        configureInitialUI()
    }
    
    func configureInitialUI() {
        // ui
        self.uriLabels.isEnabled = false
        writeButton.isEnabled = false
        writeButton.backgroundColor = UIColor.gray
        resetButtonColors()
        setTitles()
    }
    
    func setTitles() {
        switch selectedButton {
        case .text:
            uriLabels.setTitle("Text:", for: .normal)
            textInput.attributedPlaceholder = NSAttributedString(
                    string: "Enter your text here",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            textButton.backgroundColor = UIColor(named: "backgroundgreen")
        case .url:
            uriLabels.setTitle("https:// ", for: .normal)
            textInput.attributedPlaceholder = NSAttributedString(
                    string: "www.website.com",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            urlButton.backgroundColor = UIColor(named: "backgroundgreen")
        case .uri:
            uriLabels.setTitle("Custom: ", for: .normal)
            textInput.attributedPlaceholder = NSAttributedString(
                    string: "Enter custom url ",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            uriButton.backgroundColor = UIColor(named: "backgroundgreen")
        case .app:
            uriLabels.setTitle("App name: ", for: .normal)
            textInput.attributedPlaceholder = NSAttributedString(
                    string: "Enter the name of the app",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            textDevInput.attributedPlaceholder = NSAttributedString(
                    string: "Enter the name of the dev",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            appButton.backgroundColor = UIColor(named: "backgroundgreen")
        }
        
        if selectedButton == .app {
            textDevInput.isHidden = false
            appLabel.isHidden = false
        } else {
            textDevInput.isHidden = true
            appLabel.isHidden = true
        }
    }


    @IBAction func writeText(_ sender: Any) {
        self.selectedButton = .text
        resetButtonColors()
        setTitles()
        
        guard let sampleText = textInput.text else {
            disableWriteButton()
                  return
        }
        self.type = TextRecordWrite(sampleText)
        enableWriteButton()
    }

    @IBAction func writeURL(_ sender: Any) {
        self.selectedButton = .url
        resetButtonColors()
        setTitles()
        
        guard let sampleText = textInput.text else {
            disableWriteButton()
            return
        }
        guard let url = URL(string:sampleText) else {
            disableWriteButton()
            return
        }
        self.type = URLRecordWrite(url)
        enableWriteButton()
    }

    @IBAction func writeURI(_ sender: Any) {
        self.selectedButton = .uri
        resetButtonColors()
        setTitles()
        
        guard let sampleText = textInput.text else {
            disableWriteButton()
            return
        }
        guard let url = URL(string:sampleText) else {
            disableWriteButton()
            return
        }
        
        self.type = URIRecordWrite(url)
        enableWriteButton()
    }

    @IBAction func writeAppstore(_ sender: Any) {
        self.selectedButton = .app
        resetButtonColors()
        setTitles()
        
        guard let sampleText = textInput.text, let sampledev = textDevInput.text, sampleText.isEmpty == false else {
            disableWriteButton()
            return
        }
        
        self.type = AppRecordWrite(dev: sampledev, app: sampleText)
        enableWriteButton()
    }


    func enableWriteButton() {
        writeButton.isEnabled = true
        writeButton.backgroundColor = UIColor(named: "backgroundgreen")
    }
    
    func disableWriteButton() {
        writeButton.isEnabled = false
        writeButton.backgroundColor = .gray
    }

    func resetButtonColors() {
        let buttons = [textButton, urlButton, uriButton, appButton]
        buttons.forEach { $0?.backgroundColor = .clear }
        
        textInput.text = ""
    }

    @IBAction func write(_ sender: Any) {
        guard let type = self.type else { return }
        self.writer.beginWriting(type)
        writeButton.backgroundColor = UIColor(named: "backgroundgreen")
    }
}

extension WriteViewController {
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let inputText = textInput.text, !inputText.isEmpty else {
            disableWriteButton()
            return false
        }

        updateTypeBasedOnSelection(inputText)

        if self.type != nil {
            enableWriteButton()
        }
        
        return true
    }

    func updateTypeBasedOnSelection(_ inputText: String) {
        switch selectedButton {
        case .text:
            self.type = TextRecordWrite(inputText)
        case .url, .uri:
            updateTypeForURLBasedSelection(inputText)
        case .app:
            if let devText = textDevInput.text, !devText.isEmpty {
                self.type = AppRecordWrite(dev: devText, app: inputText)
            } else {
                disableWriteButton()
            }
        }
    }

    func updateTypeForURLBasedSelection(_ inputText: String) {
        guard let url = URL(string: inputText) else {
            disableWriteButton()
            return
        }

        switch selectedButton {
        case .url:
            self.type = URLRecordWrite(url)
        case .uri:
            self.type = URIRecordWrite(url)
        default:
            break
        }
    }
}
