//
//  WebView.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 15/10/24.
//

import UIKit
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let validURL = URL(string: url) {
            let request = URLRequest(url: validURL)
            webView.load(request)
        }
    }
}
