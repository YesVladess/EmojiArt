//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by YesVladess on 03.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class DocumentInfoViewController: UIViewController {

    var document: EmojiArtDocument? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        
    }
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
}
