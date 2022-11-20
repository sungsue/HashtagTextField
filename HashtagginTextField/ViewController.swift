//
//  ViewController.swift
//  HashtagginTextField
//
//  Created by sooooo on 2022/11/19.
//

import UIKit

protocol HashtagConvertTextFieldDelegate {
    var textField : UITextField { get set }
    var onConverted:(_ tags:[String])->Void {get set}
}

class HashtagConverter : NSObject, HashtagConvertTextFieldDelegate, UITextFieldDelegate {
    var onConverted: ([String]) -> Void
    
    var textField: UITextField
    
    init(textField: UITextField, onConverted:@escaping ([String])->Void) {
        self.textField = textField
        self.onConverted = onConverted
        
        super.init()
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(handleTextChanged(textField:)), for: .editingChanged)
    }
}

extension UITextField {
    func allowSpaceCharactor(string:String)->Bool{
        if let text = self.text, let lastChar = text.last, lastChar == " ", string == " " {
            print("Space Charactor is not allowed")
            return false
        }
        return true
    }
}

extension HashtagConverter {
    
    @objc func handleTextChanged(textField:UITextField){
        //print("textField Text : " + textField.text!)
//        proceedConvert(text: textField.text)
        let word = extractWord(text: textField.text)
        
        proceedConvert(text: textField.text)
        
        if let words = extractWord(text: textField.text) {
            onConverted(words)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return textField.allowSpaceCharactor(string: string)
    }
    
    func proceedConvert(text:String?){
//        if let string = text, let lastChar = string.last, lastChar == " ", let converted = convertingText(text: text) {
//                textField.text = converted + " "
//        }
        var converted = convertingText(text: text)
        if let _ = converted, let last = text?.last, last == " " {
            converted?.append(" ")
        }
        
        textField.text = converted
    }
    
    func extractWord(text:String?)->[String]?{
        if let text = text {
            return text.components(separatedBy: " ").filter({!$0.isEmpty}).map({$0.replacingOccurrences(of: "#", with: "")})
        }else{
            return nil
        }
    }
    
    func convertingText(text:String?)->String?{
        if let words = extractWord(text: text) {
            return words.map({"#"+$0}).joined(separator:" ")
        }else{
            return textField.text
        }
    }
    
    func addHashtag(tags:[String]){
        textField.text = convertingText(text: tags.joined(separator: " "))
    }
}

class ViewController: UIViewController {
    lazy var textField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Input here"
        return textfield
    }()
    
    var converter : HashtagConverter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        converter = HashtagConverter(textField: textField){ tags in
            print("update to viewModel - \(tags)")
        }
        
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view as Any, attribute: .centerX, relatedBy: .equal, toItem: textField, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view as Any, attribute: .topMargin, relatedBy: .equal, toItem: textField, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view as Any, attribute: .leftMargin, relatedBy: .equal, toItem: textField, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view as Any, attribute: .rightMargin, relatedBy: .equal, toItem: textField, attribute: .right, multiplier: 1, constant: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let words = ["aaa", "bbb", "ccc"]
        converter?.addHashtag(tags: words)
    }
}

