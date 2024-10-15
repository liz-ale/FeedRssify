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
   
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}