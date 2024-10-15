//
//  FeedRssfy_DSApp.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 14/10/24.
//

import SwiftUI
import SwiftData

@main
struct FeedRssfy_DSApp: App {
    var body: some Scene {
        WindowGroup {
            RSSreaderView()
                .modelContainer(for: FeedURL.self)
        }
    }
}
