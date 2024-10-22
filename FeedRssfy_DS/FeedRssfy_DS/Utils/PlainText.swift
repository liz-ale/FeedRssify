//
//  PlainText.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 22/10/24.
//

import Foundation
import UIKit

extension String {
    func htmlToString() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        
        // Convertimos el HTML a un `NSAttributedString`
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            
            // Extraemos el string plano desde el `NSAttributedString`
            return attributedString.string
        } else {
            return self  // Si no puede convertirlo, devolvemos la cadena original
        }
    }
}
