//
//  RssItem.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 16/10/24.
//

import Foundation
import SwiftData

@Model
class RSSItem: Identifiable {
    var id = UUID()
    var title: String
    var link: String
    var pubDate: String
    var feedName: String
    var imageURL: String?
    var detail: String
    
    init(title: String, link: String, pubDate: String, feedName: String, imageURL: String?, detail: String) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.feedName = feedName
        self.imageURL = imageURL
        self.detail = detail
    }
}
