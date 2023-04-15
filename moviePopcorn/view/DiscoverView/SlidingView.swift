//
//  SlidingView.swift
//  movie3
//
//  Created by Obuka on 6.4.23..
//

import SwiftUI

import SlidingTabView

struct SlidingView: View {
    @State private var tabIndex = 0
    @StateObject var viewModel = MovieDiscoverViewModel()
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    
    var body: some View {
        VStack{
            SlidingTabView(selection: $tabIndex, tabs: ["Now playing", "Upcoming", "Top rated", "Popular"], font: Font.caption, animation: .easeInOut, selectionBarColor: .gray)
            
            
            Spacer()
            if tabIndex == 0{
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 15) {
                        ForEach(Array(viewModel.nowPlaying.enumerated()), id: \.offset) { index, trendingItem in
                            
                            NavigationLink {
                                MovieDetailView(movie: trendingItem)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    SlidingCard(trendingItem: trendingItem)
                                    
                                    
                                }
                            }}}
                    .padding(10)
                    
                    
                    
                }
                
                
            } else if tabIndex == 1{
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 15) {
                        ForEach(Array(viewModel.upcoming.enumerated()), id: \.offset) { index, trendingItem in
                            
                            NavigationLink {
                                MovieDetailView(movie: trendingItem)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    SlidingCard(trendingItem: trendingItem)
                                    
                                    
                                }
                            }}}
                    .padding(10)
                    
                    
                    
                }
                
            }else if tabIndex == 2{
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 15) {
                        ForEach(Array(viewModel.topRated.enumerated()), id: \.offset) { index, trendingItem in
                            
                            NavigationLink {
                                MovieDetailView(movie: trendingItem)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    SlidingCard(trendingItem: trendingItem)
                                    
                                    
                                }
                            }}}
                    .padding(10)
                    
                    
                    
                }
                
            }else if tabIndex == 3{
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 15) {
                        ForEach(Array(viewModel.popular.enumerated()), id: \.offset) { index, trendingItem in
                            
                            NavigationLink {
                                MovieDetailView(movie: trendingItem)
                            } label: {
                                ZStack(alignment: .bottomLeading) {
                                    SlidingCard(trendingItem: trendingItem)
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    .padding(10)
                    
                    
                    
                }
                
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .background(Color(red:39/255,green:40/255,blue:59/255))
        .onAppear {
            viewModel.loadNowPlaying()
            viewModel.loadUpcoming()
            viewModel.loadTopRated()
            viewModel.loadPopular()
            
        }
        
    }
}

struct SlidingView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingView()
    }
}
