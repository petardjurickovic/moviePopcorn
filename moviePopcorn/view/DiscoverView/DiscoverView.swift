//
//  DiscoverView.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//


import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel = MovieDiscoverViewModel()
    @State var searchText = ""
    @StateObject var bookmarked = Bookmarked()
     
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search movies")
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                ScrollView {
                    if viewModel.trending.isEmpty {
                        Text("No Results")
                    } else {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(viewModel.trending.enumerated()), id: \.offset) { index, trendingItem in
                                    
                                    NavigationLink(
                                        destination: MovieDetailView(movie: trendingItem)
                                    ) {
                                        ZStack(alignment: .bottomLeading) {
                                            TrendingCard(trendingItem: trendingItem)
                                            
                                            Text("\(index + 1)")
                                                .font(.system(size: 100, weight: .bold))
                                                .foregroundColor(.blue)
                                                .padding(.leading, -15)
                                                .padding(.bottom, -35)
                                                .overlay(
                                                    Text("\(index + 1)")
                                                        .font(.system(size: 100, weight: .bold))
                                                        .foregroundColor(Color(red:39/255,green:40/255,blue:59/255))
                                                        .padding(.leading, -15)
                                                        .padding(.bottom, -35)
                                                        .blur(radius: 1.5)
                                                )
                                            
                                        }
                                    }
                                    .padding(15)
                                }
                                
                            }
                        }
                    }
                    
                    
                    SlidingView()
                    
                }
                
            }.background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
        }
        .background(Color(red:39/255,green:40/255,blue:59/255))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.loadTrending()
            
        }
        .environmentObject(bookmarked)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
        }
        .background(Color(red: 61/255, green: 63/255, blue: 84/255))
        .cornerRadius(8)
    }
}
