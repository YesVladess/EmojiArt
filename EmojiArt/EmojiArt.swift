//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by YesVladess on 01.12.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation

/// Model an EmojiArt. Composed of an URL image for the background and a bunch of emojis/label
/// added into it with a respective size and location.
struct EmojiArt: Codable {
    
    /// URL for the background image
    var url: URL
    
    /// The emojis that are dropped into the docuemnt
    var emojis: [EmojiInfo] = []
     
    /// Represents a dropped emoji: location, text and size
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    /// Create new EmojiArt with given URL (should be an image URL), and a bunch of emojis
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    /// JSON Data representing the current object.
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    /// Create object from given JSON Data.
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        }
        else {
            return nil
        }
    }
}
