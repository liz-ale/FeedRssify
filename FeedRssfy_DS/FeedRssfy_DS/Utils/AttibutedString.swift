//
//  AttibutedString.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 22/10/24.
//

import Foundation
import SwiftUI

extension AttributedString {
    init?(html: String) {
        guard let data = html.data(using: .utf8) else { return nil }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            self.init(attributedString)
        } else {
            return nil
        }
    }
}
