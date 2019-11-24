//
//  ViewController.swift
//  EmojiArt
//
//  Created by YesVladess on 22.11.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var emojiArtView = EmojiArtView()
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    /// View that handles the drop interaction(s)
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            // Set `self` as the delegate for drop interactions
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    var emojiArtBackgroundImage: UIImage? {
        get {
            return emojiArtView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            scrollView?.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
        }
    }
    
    /// Return whether the delegate is interested in the given session
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Drag must be URL and UIImage. (Using NSURL because this is an objective-c api. Although we
        // have automatic-bridging between objective-c's NSURL and swift's URL, we must use NSURL.self
        // because we're passing the specific class to `canLoadObjects`)
        return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    /// Tells the delegate the drop session has changed.
    ///
    /// You must implement this method if the drop interaction’s view can accept drop activities. If
    /// you don’t provide this method, the view cannot accept any drop activities.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // Copy whatever is being dropped into the view
        return UIDropProposal(operation: .copy)
    }
    
    /// Tells the delegate it can request the item provider data from the session’s drag items.
    ///
    /// You can request a drag item's itemProvider data within the scope of this method only and
    /// not at any other time.
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        // Image fetcher allows to fetch an image in the background based on given URL
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = image
            }
        }
        
        // Process the array of URL's
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            // We only care about the first one. If there were others, ignore them.
            if let url = nsurls.first as? URL {
                // Asynchronously fetch the image based on the given url.
                self.imageFetcher.fetch(url)
            }
        }
        
        // Process the array of images
        session.loadObjects(ofClass: UIImage.self) { images in
            // We only care about the first one. If there were others, ignore them.
            if let image = images.first as? UIImage {
                // Set the image as the fetcher's backup
                self.imageFetcher.backup = image
            }
        }
    }
    
    /// Helper class for fetching images from the network in an async. way
    private var imageFetcher: ImageFetcher!
    
    var emojis: [String] = "😀😁😂🤣😃😄😅😆😉😊😋😎😍😘😗😙😚☺️🙂🤗🤩🤔🤨😐😑😶🙄😏😣😥😮🤐😯😪😫😴😌😛😜😝🤤😒😓😔😕🙃🤑😲☹️🙁😖😞😟😤😢😭😦😧😨😩🤯😬😰😱😳🤪😵😡😠🤬😷🤒🤕🤢🤮🤧😇🤠🤡🤥🤫🤭🧐🤓😈👿👹👺💀👻👽🤖💩😺😸😹😻😼😽🙀😿😾👶👦👧👨👩👴👵👨‍⚕️👩‍⚕️👨‍🎓👩‍🎓👨‍⚖️👩‍⚖️👨‍🌾👩‍🌾👨‍🍳👩‍🍳👨‍🔧👩‍🔧👨‍🏭👩‍🏭👨‍💼👩‍💼👨‍🔬👩‍🔬👨‍💻👩‍💻👨‍🎤👩‍🎤👨‍🎨👩‍🎨👨‍✈️👩‍✈️👨‍🚀👩‍🚀👨‍🚒👩‍🚒👮👮‍♂️👮‍♀️🕵🕵️‍♂️🕵️‍♀️💂💂‍♂️💂‍♀️👷👷‍♂️👷‍♀️🤴👸👳👳‍♂️👳‍♀️👲🧕🧔👱👱‍♂️👱‍♀️🤵👰🤰🤱👼🎅🤶🧙‍♀️🧙‍♂️🧚‍♀️🧚‍♂️🧛‍♀️🧛‍♂️🧜‍♀️🧜‍♂️🧝‍♀️🧝‍♂️🧞‍♀️🧞‍♂️🧟‍♀️🧟‍♂️🙍🙍‍♂️🙍‍♀️🙎🙎‍♂️🙎‍♀️🙅🙅‍♂️🙅‍♀️🙆🙆‍♂️🙆‍♀️💁💁‍♂️💁‍♀️🙋🙋‍♂️🙋‍♀️🙇🙇‍♂️🙇‍♀️🤦🤦‍♂️🤦‍♀️🤷🤷‍♂️🤷‍♀️💆💆‍♂️💆‍♀️💇💇‍♂️💇‍♀️🚶🚶‍♂️🚶‍♀️🏃🏃‍♂️🏃‍♀️💃🕺👯👯‍♂️👯‍♀️🧖‍♀️🧖‍♂️🕴🗣👤👥👫👬👭💏👨‍❤️‍💋‍👨👩‍❤️‍💋‍👩💑👨‍❤️‍👨👩‍❤️‍👩👪👨‍👩‍👦👨‍👩‍👧👨‍👩‍👧‍👦👨‍👩‍👦‍👦👨‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👩‍👩‍👦👩‍👩‍👧👩‍👩‍👧‍👦👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👦👨‍👦‍👦👨‍👧👨‍👧‍👦👨‍👧‍👧👩‍👦👩‍👦‍👦👩‍👧👩‍👧‍👦👩‍👧‍👧🤳💪👈👉☝️👆🖕👇✌️🤞🖖🤘🖐✋👌👍👎✊👊🤛🤜🤚👋🤟✍️👏👐🙌🤲🙏🤝💅👂👃👣👀👁🧠👅👄💋👓🕶👔👕👖🧣🧤🧥🧦👗👘👙👚👛👜👝🎒👞👟👠👡👢👑👒🎩🎓🧢⛑💄💍🌂💼👐🏻🙌🏻👏🏻🙏🏻👍🏻👎🏻👊🏻✊🏻🤛🏻🤜🏻🤞🏻✌🏻🤘🏻👌🏻👈🏻👉🏻👆🏻👇🏻☝🏻✋🏻🤚🏻🖐🏻🖖🏻👋🏻🤙🏻💪🏻🖕🏻✍🏻🤳🏻💅🏻👂🏻👃🏻👶🏻👦🏻👧🏻👨🏻👩🏻👱🏻‍♀️👱🏻👴🏻👵🏻👲🏻👳🏻‍♀️👳🏻👮🏻‍♀️👮🏻👷🏻‍♀️👷🏻💂🏻‍♀️💂🏻🕵🏻‍♀️🕵🏻👩🏻‍⚕️👨🏻‍⚕️👩🏻‍🌾👨🏻‍🌾👩🏻‍🍳👨🏻‍🍳👩🏻‍🎓👨🏻‍🎓👩🏻‍🎤👨🏻‍🎤👩🏻‍🏫👨🏻‍🏫👩🏻‍🏭👨🏻‍🏭👩🏻‍💻👨🏻‍💻👩🏻‍💼👨🏻‍💼👩🏻‍🔧👨🏻‍🔧👩🏻‍🔬👨🏻‍🔬👩🏻‍🎨👨🏻‍🎨👩🏻‍🚒👨🏻‍🚒👩🏻‍✈️👨🏻‍✈️👩🏻‍🚀👨🏻‍🚀👩🏻‍⚖️👨🏻‍⚖️🤶🏻🎅🏻👸🏻🤴🏻👰🏻🤵🏻👼🏻🤰🏻🙇🏻‍♀️🙇🏻💁🏻💁🏻‍♂️🙅🏻🙅🏻‍♂️🙆🏻🙆🏻‍♂️🙋🏻🙋🏻‍♂️🤦🏻‍♀️🤦🏻‍♂️🤷🏻‍♀️🤷🏻‍♂️🙎🏻🙎🏻‍♂️🙍🏻🙍🏻‍♂️💇🏻💇🏻‍♂️💆🏻💆🏻‍♂️🕴🏻💃🏻🕺🏻🚶🏻‍♀️🚶🏻🏃🏻‍♀️🏃🏻🏋🏻‍♀️🏋🏻🤸🏻‍♀️🤸🏻‍♂️⛹🏻‍♀️⛹🏻🤾🏻‍♀️🤾🏻‍♂️🏌🏻‍♀️🏌🏻🏄🏻‍♀️🏄🏻🏊🏻‍♀️🏊🏻🤽🏻‍♀️🤽🏻‍♂️🚣🏻‍♀️🚣🏻🏇🏻🚴🏻‍♀️🚴🏻🚵🏻‍♀️🚵🏻🤹🏻‍♀️🤹🏻‍♂️🛀🏻👐🏼🙌🏼👏🏼🙏🏼👍🏼👎🏼👊🏼✊🏼🤛🏼🤜🏼🤞🏼✌🏼🤘🏼👌🏼👈🏼👉🏼👆🏼👇🏼☝🏼✋🏼🤚🏼🖐🏼🖖🏼👋🏼🤙🏼💪🏼🖕🏼✍🏼🤳🏼💅🏼👂🏼👃🏼👶🏼👦🏼👧🏼👨🏼👩🏼👱🏼‍♀️👱🏼👴🏼👵🏼👲🏼👳🏼‍♀️👳🏼👮🏼‍♀️👮🏼👷🏼‍♀️👷🏼💂🏼‍♀️💂🏼🕵🏼‍♀️🕵🏼👩🏼‍⚕️👨🏼‍⚕️👩🏼‍🌾👨🏼‍🌾👩🏼‍🍳👨🏼‍🍳👩🏼‍🎓👨🏼‍🎓👩🏼‍🎤👨🏼‍🎤👩🏼‍🏫👨🏼‍🏫👩🏼‍🏭👨🏼‍🏭👩🏼‍💻👨🏼‍💻👩🏼‍💼👨🏼‍💼👩🏼‍🔧👨🏼‍🔧👩🏼‍🔬👨🏼‍🔬👩🏼‍🎨👨🏼‍🎨👩🏼‍🚒👨🏼‍🚒👩🏼‍✈️👨🏼‍✈️👩🏼‍🚀👨🏼‍🚀👩🏼‍⚖️👨🏼‍⚖️🤶🏼🎅🏼👸🏼🤴🏼👰🏼🤵🏼👼🏼🤰🏼🙇🏼‍♀️🙇🏼💁🏼💁🏼‍♂️🙅🏼🙅🏼‍♂️🙆🏼🙆🏼‍♂️🙋🏼🙋🏼‍♂️🤦🏼‍♀️🤦🏼‍♂️🤷🏼‍♀️🤷🏼‍♂️🙎🏼🙎🏼‍♂️🙍🏼🙍🏼‍♂️💇🏼💇🏼‍♂️💆🏼💆🏼‍♂️🕴🏼💃🏼🕺🏼🚶🏼‍♀️🚶🏼🏃🏼‍♀️🏃🏼🏋🏼‍♀️🏋🏼🤸🏼‍♀️🤸🏼‍♂️⛹🏼‍♀️⛹🏼🤾🏼‍♀️🤾🏼‍♂️🏌🏼‍♀️🏌🏼🏄🏼‍♀️🏄🏼🏊🏼‍♀️🏊🏼🤽🏼‍♀️🤽🏼‍♂️🚣🏼‍♀️🚣🏼🏇🏼🚴🏼‍♀️🚴🏼🚵🏼‍♀️🚵🏻🤹🏼‍♀️🤹🏼‍♂️🛀🏼".map { String($0) }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for:
            UIFont.preferredFont(forTextStyle: .body).withSize(45.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell {
            let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
            emojiCell.label.attributedText = text
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath:IndexPath) -> [UIDragItem] {
        if let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as?
            EmojiCollectionViewCell)?.label.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext) as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
            // The index path where the drop would be inserted
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            // Process each item
            for item in coordinator.items {
                // Is this a local drag?
                if let sourceIndexPath = item.sourceIndexPath {
                    // Item should contain an attributed string
                    if let attributedString = item.dragItem.localObject as? NSAttributedString {
                        // performBatchUpdates: Animates multiple insert, delete, reload, and move operations as a group.
                        collectionView.performBatchUpdates({
                            // Update model
                            emojis.remove(at: sourceIndexPath.item)
                            emojis.insert(attributedString.string, at: destinationIndexPath.item)
                            // Update view
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        })
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    }
                }
                // This is NOT a local drag (drop comes from somewhere else)
                else {
                    // Temporarily drop a "loading" cell while the actual one (provided by the itemProvider) loads
                    let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(
                            insertionIndexPath: destinationIndexPath,
                            reuseIdentifier: "DropPlaceholderCell" // "DropPlaceholderCell" contains a loading spinning wheel
                        )
                    )
                    // Load the attributed-string into the collectionView
                    item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                        // Update UI in the main queue
                        DispatchQueue.main.async {
                            // Check if provider is a string
                            if let attributedString = provider as? NSAttributedString {
                                // All good! do the actual insertion (exchanges the placeholder cell for one with the final content.)
                                placeholderContext.commitInsertion { insertionIndexPath in
                                    self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                                }
                            } else {
                                // We couldn't do insertion, delete the placeholder
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }
    }
