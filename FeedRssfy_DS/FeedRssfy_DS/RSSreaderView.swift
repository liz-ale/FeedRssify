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
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            VStack {
                if feeds.isEmpty {
                    Text("Aún no hay noticias que mostrar")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(feeds) { feed in
                            NavigationLink(destination: WebView(url: feed.url)) {
                                VStack(alignment: .leading) {
                                    Text(feed.name)
                                        .font(.headline)
                                    Text(feed.url)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .swipeActions {
                                Button("Delete") {
                                    context.delete(feed)
                                }
                            }
                        }
                        
                    }
//                    .refreshable {
//                        await refreshFeeds()
//                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAlert = true
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                        Text("Feed")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("RSSfy")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
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
        }
        .navigationViewStyle(.stack)
    }
    
//    private func refreshFeeds() async {
//        isRefreshing = true
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        isRefreshing = false
//    }

    private func saveFeed() {
        guard !newFeedName.isEmpty, !newFeedURL.isEmpty else { return }
        
        let newFeed = FeedURL(name: newFeedName, url: newFeedURL)
        context.insert(newFeed)
        

    }
}

#Preview {
    RSSreaderView()
}
