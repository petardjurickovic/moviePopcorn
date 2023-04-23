//
//  MovieDetailView.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//


import Foundation
import SwiftUI
import SlidingTabView


struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var model = MovieDetailsViewModel()
    let movie: Movie
    let headerHeight: CGFloat = 210
    let screenWidth = UIScreen.main.bounds.width
    
    @State private var tabIndex = 0
    @StateObject var viewModel = MovieDiscoverViewModel()
    @EnvironmentObject var bookmarked: Bookmarked
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    
    var body: some View {
        
        
        
        VStack(spacing: 0){
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.bottom, 20)
                .padding(.leading, 20)
                
                Spacer()
                Text("Details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Spacer()
                Button(action: {
                    if bookmarked.contains(movie) {
                        bookmarked.remove(movie)
                    } else {
                        bookmarked.add(movie)
                    }
                }) {
                    Image(systemName: bookmarked.contains(movie) ? "bookmark.fill" : "bookmark")
                }
                .padding(.bottom, 20)
                .padding(.trailing, 20)
                
            }

            VStack{
                
                ZStack{
                    AsyncImage(url: movie.backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: screenWidth, maxHeight: headerHeight)
                    } placeholder: {
                        ProgressView()
                    }
                
                }
                
                VStack{
                    
                    HStack{
                        AsyncImage(url: movie.poster) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 95, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                            //.offset(x: -screenWidth/3, y: headerHeight/2)
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                        VStack{
                            
                            Text(movie.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(height: 60)
                                .lineLimit(nil)
                            
                        }.padding(.top, 30)
                        Spacer()
                        HStack{
                            Image(systemName: "star")
                            
                            Text(String(format: "%.1f", movie.vote_average))
                            
                        }
                        .padding(.horizontal, 8)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.orange)
                        .offset(x: 0, y: -30)
                        
                        
                        
                    }.offset(x: 0, y: -50)
                    .padding(.leading, 30)
                    .padding(.trailing, 10)
                    
                }
                
                HStack{
                    Text(String(movie.release_date.prefix(4)))

                    Text("|")
                    
                    if let runtime = movie.runtime {
                        Text("\(runtime) min")
                    } else {
                        Text("? min")
                    }

                    Text("|")
                    
                    if let genre = movie.genres?.first?.name {
                        Text(String(genre))
                    }else {
                        Text("unknown genre")
                    }
                }.offset(x: 0, y: -50)
                .foregroundColor(.gray)
                .padding()
            }
            VStack{
                
                SlidingTabView(selection: $tabIndex, tabs: ["About Movie", "Reviews", "Cast"], font: Font.caption, animation: .easeInOut, selectionBarColor: .gray)
                
                
                Spacer()
                if tabIndex == 0{
                    ScrollView{
                        Text(movie.overview)}
                }else if tabIndex == 1 {
                    ScrollView {
                        LazyVStack {
                            ForEach(model.reviews) { review in
                                HStack {
                                    AsyncImage(url: review.reviewerPhotoURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(review.author)
                                            .font(.headline)
                                        Text(review.content)
                                            .font(.body)
                                        HStack {
                                            if let rating = review.author_details.rating {
                                                Text(String(rating))
                                                    .font(.caption)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.vertical)
                                Divider()
                                    .background(Color.blue)
                                    .frame(height: 5)
                                    .padding(.horizontal)
                                
                            }
                        }
                    }
                }else if tabIndex == 2{
                    
                    let allCastProfiles = Array(Set(model.castProfiles)) // remove duplicates
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(allCastProfiles, id: \.id) { cast in
                                VStack {
                                    AsyncImage(url: cast.photoUrl) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 75, height: 75)
                                            .clipShape(Circle())
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 75, height: 75)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    
                                    
                                    Text(cast.name)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    }
                  
                }
                Spacer()
            }.offset(x: 0, y: -50)
            .background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
            .foregroundColor(.white)
            .padding()
        }
        .background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
 
        Spacer()
        
            .toolbar(.hidden, for: .navigationBar)
            .foregroundColor(.white)
            .task {
                await model.movieCredits(for: movie.id)
                await model.loadCastProfiles()
                await model.loadReviews(for: movie.id)
            }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: .preview)
    }
}
