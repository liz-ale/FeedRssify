//
//  ContentView.swift
//  FeedRssfy_DS
//
//  Created by lizbeth.alejandro on 14/10/24.
//

import SwiftUI
import SwiftData

struct RSSreaderView: View {
    @Environment(\.modelContext) private var context
    @Query private var feeds: [FeedURL]
    
    @State private var isShowingAlert = false
    @State private var newFeedName: String = ""
    @State private var newFeedURL: String = ""
    @State private var rssItems: [RSSItem] = []  // Para almacenar las noticias
    
    var body: some View {
        NavigationView {
            VStack {
                if rssItems.isEmpty {
                    Text("Aún no hay noticias que mostrar")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(rssItems) { item in
                        NavigationLink(destination: WebViewContainer(url: item.link)) {
                            HStack {
                                // Cargar imagen si está disponible
                                if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.feedName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(item.pubDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("RSSfy", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAlert = true
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                        Text("Feed")
                    }
                }
            }
            .alert("Nuevo Feed", isPresented: $isShowingAlert) {
                TextField("Nombre", text: $newFeedName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("URL", text: $newFeedURL)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Guardar", action: saveFeed)
                Button("Cancelar", role: .cancel, action: { })
            } message: {
                Text("Introduce el nombre y la URL del feed.")
            }
            .onAppear {
                // Cargar noticias del primer feed
                if let firstFeed = feeds.first {
                    loadRSSFeed(from: firstFeed.url, feedName: firstFeed.name)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func saveFeed() {
        guard !newFeedName.isEmpty, !newFeedURL.isEmpty else { return }
        
        let newFeed = FeedURL(name: newFeedName, url: newFeedURL)
        context.insert(newFeed)
        
        // Cargar las noticias del nuevo feed
        loadRSSFeed(from: newFeedURL, feedName: newFeedName)
    }

    private func loadRSSFeed(from urlString: String, feedName: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                parseRSS(data: data, feedName: feedName)
            }
        }
        task.resume()
    }
    
    private func parseRSS(data: Data, feedName: String) {
        let parser = XMLParser(data: data)
        let rssParserDelegate = RSSParserDelegate(feedName: feedName)
        parser.delegate = rssParserDelegate
        
        if parser.parse() {
            DispatchQueue.main.async {
                self.rssItems = rssParserDelegate.items
            }
        }
    }
}

struct WebViewContainer: View {
    let url: String
    
    var body: some View {
        WebView(url: url)
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false) // Muestra el botón de regresar
    }
}

#Preview {
    RSSreaderView()
}
