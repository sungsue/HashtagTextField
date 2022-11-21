//
//  HashtagConverter.swift
//  HashtagginTextField
//
//  Created by andrew on 2022/11/21.
//

import Foundation
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

extension HashtagConverter {
    
    @objc func handleTextChanged(textField:UITextField){
        let word = extractWord(text: textField.text)
        
        proceedConvert(text: textField.text)
        
        if let words = extractWord(text: textField.text) {
            onConverted(words)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.allowSpaceCharacter(string: string)
    }
    
    func proceedConvert(text:String?){
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

extension UITextField {
    func allowSpaceCharacter(string:String)->Bool{
        if let text = self.text, let lastChar = text.last, lastChar == " ", string == " " {
            print("Space Character is not allowed")
            return false
        }
        return true
    }
}
