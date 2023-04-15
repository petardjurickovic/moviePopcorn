//
//  BookmarkedView.swift
//  movie3
//
//  Created by Obuka on 11.4.23..
//

import SwiftUI

struct BookmarkedView: View {
    @ObservedObject var bookmarked = Bookmarked()
    
    var body: some View {
        VStack(spacing: 0){
            NavigationView {
                ScrollView{
                    LazyVStack() {
                        ForEach(Array(bookmarked.movies).sorted { $0.bookmarkDate ?? Date() > $1.bookmarkDate ?? Date() }
                        ) { item in
                            // NavigationLink(destination: MovieDetailView(movie: item).environmentObject(bookmarked)) {
                            HStack {
                                VStack{
                                    AsyncImage(url: item.backdropURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 120)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 80, height: 120)
                                    }
                                    .clipped()
                                    .cornerRadius(10)
                                }
                                
                                VStack(alignment:.leading) {
                                    Text(item.title)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding(.bottom, 10)
                                    
                                    
                                    HStack {
                                        Image(systemName: "star")
                                        Text(String(format: "%.1f", item.vote_average))
                                        Spacer()
                                    }.padding(.bottom, 3)
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    VStack(alignment: .leading){
                                        HStack {
                                            
                                            Image(systemName: "puzzlepiece.extension")
                                            if let genre = item.genres?.first?.name {
                                                Text(String(genre))
                                            }
                                        }.padding(.bottom, 3)
                                        
                                        HStack {
                                            
                                            Image(systemName: "calendar")
                                            Text(String(item.release_date.prefix(4)))
                                            
                                        }.padding(.bottom, 3)
                                        HStack {
                                            Image(systemName: "clock")
                                            Text(String(item.runtime!) + " min")
                                            
                                        }.padding(.bottom, 3)
                                        
                                    }
                                    .foregroundColor(.white)
                                    .font(.caption)
                                   
                                }
                                Spacer()
                            }
                            .padding()
                            .cornerRadius(20)
                            
                            .padding(.horizontal)
                        }
                        // }
                    }
                .onAppear {
                        bookmarked.readDataFromFile()
                    }
                }.background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
            }
            
        }
    }
    
}


struct BookmarkedView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkedView()
    }
}
