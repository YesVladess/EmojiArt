//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by YesVladess on 01.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

/// CollectionViewCell with an input textField.
class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    /// This is called inside `textFieldDidEndEditing`.
    ///
    /// You may set this to do custom things when the text field ends editing.
    var resignationHandler: (()->Void)?
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // If user provided a resignationHandler, call it
        resignationHandler?()
    }
    
    /// Text field should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
