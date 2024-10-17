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
    var pubDate: String // Fecha de publicación
    var feedName: String // Nombre del feed (ingresado por el usuario)
    var imageURL: String? // Imagen de la noticia (opcional)
    
    init(title: String, link: String, pubDate: String, feedName: String, imageURL: String?) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.feedName = feedName
        self.imageURL = imageURL
    }
}
