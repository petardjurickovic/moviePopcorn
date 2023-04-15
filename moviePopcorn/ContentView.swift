//
//  ContentView.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Image(systemName: "popcorn")
                }
            SearchMoviesView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            BookmarkedView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                }
        }.background(Color(red:39/255,green:40/255,blue:59/255))
            .onAppear {
                UITabBar.appearance().barTintColor = UIColor(red:39/255,green:40/255,blue:59/255, alpha: 1.0)
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
