//
//  RSSParserDelegate.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 16/10/24.
//

import Foundation

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var items: [RSSItem] = []
    var currentElement = ""
    var currentTitle: String = ""
    var currentLink: String = ""
    var currentPubDate: String = ""
    var currentImageURL: String? = nil
    var feedName: String
    
    init(feedName: String) {
        self.feedName = feedName
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentPubDate = ""
            currentImageURL = nil
        }
        
        // Si hay una imagen
        if elementName == "media:thumbnail" || elementName == "enclosure", let url = attributeDict["url"] {
            currentImageURL = url
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                pubDate: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines),
                feedName: feedName,
                imageURL: currentImageURL
            )
            items.append(rssItem)
        }
    }
}
