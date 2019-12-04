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
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func updateUI() {
        if sizeLabel != nil, createdLabel != nil, let url = document?.fileURL,
            let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? "unknown") bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = shortDateFormatter.string(from: created)
            }
        }
        if thumbnailImageView != nil, thumbnailAspectRaio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRaio)
            thumbnailAspectRaio = NSLayoutConstraint(
                item: thumbnailImageView!,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0)
            thumbnailImageView.addConstraint(thumbnailAspectRaio)
        }
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnToDocumentButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    @IBAction func done() {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var returnToDocumentButton: UIButton!
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet var thumbnailAspectRaio: NSLayoutConstraint!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
}
