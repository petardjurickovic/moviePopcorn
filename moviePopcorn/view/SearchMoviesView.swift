//
//  SearchMoviesView.swift
//  movie3
//
//  Created by Obuka on 11.4.23..
//
import SwiftUI

struct SearchMoviesView: View {
    @ObservedObject var viewModel = MovieDiscoverViewModel()
    @State private var searchText = ""
    var test = ""
    
    @State var runtime: Int?
      @State var genres: [String]?
      
    
    var body: some View {
        NavigationView {
            VStack(){
                
                ScrollView{
                    LazyVStack() {
                      ForEach(viewModel.searchResults) { item in
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
                                            
                                            Image(systemName: "calendar")
                                            Text(String(item.release_date.prefix(4)))

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
                    }
                }
            }.background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    if newValue.count > 2 {
                        viewModel.searchMovies(withTitle: newValue)
                    }
                }
        }
        .navigationTitle("Search Movies")
        
    }
}


struct SearchMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMoviesView()
    }
}
