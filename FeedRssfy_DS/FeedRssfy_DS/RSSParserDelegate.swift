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
    var currentDescription: String = ""
    var currentContent: String = ""  // Para almacenar el contenido completo
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
            currentDescription = ""
            currentContent = ""  // Reiniciar contenido completo
            currentImageURL = nil
        }
        
        // Detectar la imagen si está presente
        if elementName == "media:thumbnail" || elementName == "enclosure" || elementName == "media:content", let url = attributeDict["url"] {
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
        case "description":
            currentDescription += string
        case "content:encoded":  // Contenido completo
            currentContent += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if currentImageURL == nil {
                currentImageURL = extractImageURL(from: currentDescription)
            }
            
            // Decidir qué usar, si `content:encoded` está disponible, se prefiere
            let fullContent = currentContent.isEmpty ? currentDescription : currentContent
            
            let rssItem = RSSItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                link: currentLink.trimmingCharacters(in: .whitespacesAndNewlines),
                pubDate: currentPubDate.trimmingCharacters(in: .whitespacesAndNewlines),
                feedName: feedName,
                imageURL: currentImageURL,
                detail: fullContent
            )
            items.append(rssItem)
        }
    }
    
    // Extraer la URL de imagen del contenido HTML (en caso de estar dentro del CDATA en <description>)
    private func extractImageURL(from description: String) -> String? {
        let pattern = "(?i)<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = description as NSString
            let results = regex.firstMatch(in: description, options: [], range: NSRange(location: 0, length: nsString.length))
            if let matchRange = results?.range(at: 1) {
                return nsString.substring(with: matchRange)
            }
        }
        return nil
    }
}
