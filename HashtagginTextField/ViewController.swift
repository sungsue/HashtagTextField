//
//  ViewController.swift
//  HashtagginTextField
//
//  Created by sooooo on 2022/11/19.
//

import UIKit


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

