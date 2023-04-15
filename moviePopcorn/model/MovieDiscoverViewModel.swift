//
//  MovieDiscoverViewModel.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//

import Foundation
import Combine

class MovieDiscoverViewModel: ObservableObject {
    
    @Published var trending: [Movie] = []
    @Published var upcoming: [Movie] = []
    @Published var nowPlaying: [Movie] = []
    @Published var popular: [Movie] = []
    @Published var topRated: [Movie] = []
    @Published var genres: [Movie.Genre] = []
    @Published var searchResults: [Movie] = []
    

    static let apiKey = "368399178670a4500a28127845eb116f"
    
    private var cancellables: Set<AnyCancellable> = []
    
    func loadMovies(from endpoint: String) -> AnyPublisher<[Movie], Error> {
        let url = URL(string: endpoint + "&append_to_response=videos")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Results.self, decoder: JSONDecoder())
            .map { $0.results }
            .flatMap { movies -> AnyPublisher<[Movie], Error> in
                let publishers = movies.map { movie -> AnyPublisher<Movie, Error> in
                    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
                    print("https://api.themoviedb.org/3/movie/\(movie.id)?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")
                    print("test2")
                    return URLSession.shared.dataTaskPublisher(for: url)
                        .map { $0.data }
                        .decode(type: Movie.self, decoder: JSONDecoder())
                        .catch { error -> AnyPublisher<Movie, Error> in
                            print("Error loading movie with id \(movie.id): \(error.localizedDescription)")
                            return Empty<Movie, Error>().eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
                return Publishers.Sequence(sequence: publishers)
                    .flatMap(maxPublishers: .max(5)) { $0 }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
  
    
    
    //needs runtime and genres
//    func loadMovies(from endpoint: String) -> AnyPublisher<[Movie], Error> {
//        let url = URL(string: endpoint)!
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: TrendingResults.self, decoder: JSONDecoder())
//            .map { $0.results }
//            .eraseToAnyPublisher()
//    }

    
    func loadTrending() {
        loadMovies(from: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
            .receive(on: DispatchQueue.main) // Switch execution to main thread
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error loading upcoming movies: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.trending = movies
            })
            .store(in: &cancellables)
    }
    
    
    func loadUpcoming() {
        loadMovies(from: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
            .receive(on: DispatchQueue.main) // Switch execution to main thread
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error loading upcoming movies: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.upcoming = movies
            })
            .store(in: &cancellables)
    }
    
    func loadTopRated() {
        loadMovies(from: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
            .receive(on: DispatchQueue.main) // Switch execution to main thread
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error loading upcoming movies: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.topRated = movies
            })
            .store(in: &cancellables)
    }
    
    
    func loadPopular() {
        loadMovies(from: "https://api.themoviedb.org/3/movie/popular?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
            .receive(on: DispatchQueue.main) // Switch execution to main thread
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error loading upcoming movies: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.popular = movies
            })
            .store(in: &cancellables)
    }
    
    
    func loadNowPlaying() {
        loadMovies(from: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
            .receive(on: DispatchQueue.main) // Switch execution to main thread
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error loading upcoming movies: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                self.nowPlaying = movies
            })
            .store(in: &cancellables)
    }
    
    
    
    func searchMovies(withTitle title: String) {
        let query = title.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&query=\(query)&page=1")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Results.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] results in
                self?.searchResults = results
            })
            .store(in: &cancellables)
        
        print(searchResults)
        print("test")
        
    }
    
    /*
     //before using combine
     func loadGenres() async throws -> [Movie.Genre] {
     let genresURL = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(MovieDiscoverViewModel.apiKey)")!
     let (genresData, _) = try await URLSession.shared.data(from: genresURL)
     let genresResult = try JSONDecoder().decode(Genres.self, from: genresData)
     return genresResult.genres
     }
     
     
     func loadMovies(from endpoint: String) async throws -> [Movie] {
     let url = URL(string: endpoint + "&append_to_response=videos")!
     let (data, _) = try await URLSession.shared.data(from: url)
     let results = try JSONDecoder().decode(TrendingResults.self, from: data)
     var movies = results.results
     let genres = try await loadGenres()
     for i in 0..<movies.count {
     let genreIDs = movies[i].genre_ids ?? []
     let genreNames = genres.filter { genreIDs.contains($0.id) }.map { $0.name }
     movies[i].genres = genreNames.map { Movie.Genre(id: 0, name: $0) }
     
     // Add runtime to each movie
     let detailsEndpoint = "https://api.themoviedb.org/3/movie/\(movies[i].id)?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US"
     let detailsURL = URL(string: detailsEndpoint)!
     let (detailsData, _) = try await URLSession.shared.data(from: detailsURL)
     let movieDetails = try JSONDecoder().decode(Movie.self, from: detailsData)
     movies[i].runtime = movieDetails.runtime
     }
     return movies
     }
     
     func loadTrending() {
     Task {
     do {
     trending = try await loadMovies(from: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(MovieDiscoverViewModel.apiKey)")
     } catch {
     print(error.localizedDescription)
     }
     }
     }
     
     func loadUpcoming() {
     Task {
     do {
     upcoming = try await loadMovies(from: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
     } catch {
     print(error.localizedDescription)
     }
     }
     }
     
     func loadTopRated() {
     Task {
     do {
     topRated = try await loadMovies(from: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
     } catch {
     print(error.localizedDescription)
     }
     }
     }
     
     func loadPopular() {
     Task {
     do {
     popular = try await loadMovies(from: "https://api.themoviedb.org/3/movie/popular?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
     } catch {
     print(error.localizedDescription)
     }
     }
     }
     
     func loadNowPlaying() {
     Task {
     do {
     nowPlaying = try await loadMovies(from: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1")
     } catch {
     print(error.localizedDescription)
     }
     }
     }
     
     func search(term: String) {
     Task {
     let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US&page=1&include_adult=false&query=\(term)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
     do {
     let (data, _) = try await URLSession.shared.data(from: url)
     let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
     searchResults = trendingResults.results
     } catch {
     print(error.localizedDescription)
     }
     }
     }*/
    
}
