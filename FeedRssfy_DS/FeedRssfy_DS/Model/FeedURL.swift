//
//  FeedURL.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 14/10/24.
//

import Foundation
import SwiftData

@Model
class FeedURL {
    var id: UUID
    var name: String
    var url: String
    
    init(id: UUID = UUID(), name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
