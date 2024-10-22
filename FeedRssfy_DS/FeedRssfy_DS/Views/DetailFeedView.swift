//
//  DetailFeedView.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 22/10/24.
//

import Foundation
import SwiftUI

struct DetailFeedView: View {
    let item: RSSItem
    @State private var selectedFontSize: CGFloat = 16
    @State private var isDarkMode: Bool = false
    @State private var selectedFont: Font = .body
    @State private var showSettingsSheet = false

    var body: some View {
        VStack {
            ScrollView {
                // Imagen
                if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                }

                // Título
                Text(item.title)
                    .font(selectedFont)
                    .fontWeight(.bold)
                    .font(.system(size: selectedFontSize))
                    .padding(.top, 10)

                // Autor y fecha
                HStack {
                    Text("Por: \(item.feedName)")
                        .font(.subheadline)
                    Spacer()
                    Text(item.pubDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.top, .leading, .trailing], 16)

                // Mostrar la descripción completa con formato
                if let formattedContent = AttributedString(html: item.detail) {
                    Text(formattedContent)
                        .font(.system(size: selectedFontSize))
                        .padding([.top, .leading, .trailing], 16)
                } else {
                    Text(item.detail)
                        .font(.system(size: selectedFontSize))
                        .padding([.top, .leading, .trailing], 16)
                }
            }
        }
        //.navigationTitle("Detalle de Noticia")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {

                Button(action: {
                    shareArticle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }

                Button(action: {
                    openInBrowser(url: item.link)
                }) {
                    Image(systemName: "safari")
                }

                Button(action: {
                    showSettingsSheet.toggle()
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView(selectedFontSize: $selectedFontSize, isDarkMode: $isDarkMode, selectedFont: $selectedFont)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)  // Cambiar tema
    }

    private func shareArticle() {
        let activityVC = UIActivityViewController(activityItems: [item.link], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }

    private func openInBrowser(url: String) {
        if let articleURL = URL(string: url) {
            UIApplication.shared.open(articleURL)
        }
    }
}


