//
//  Bookmarked.swift
//  movie3
//
//  Created by Obuka on 11.4.23..
//

import Foundation

class Bookmarked: ObservableObject {
    
    @Published var movies: Set<Movie> = []

    init() {
        readDataFromFile()
    }

    func contains(_ movie: Movie) -> Bool {
        movies.contains(movie)
    }

    func add(_ movie: Movie) {
        objectWillChange.send()
        var mutableMovie = movie
        mutableMovie.bookmarkDate = Date()
        movies.insert(mutableMovie)
        saveDataToFile()
    }

    func remove(_ movie: Movie) {
        objectWillChange.send()
        movies.remove(movie)
        saveDataToFile()
    }

     func readDataFromFile() {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("bookmarkedMovies.json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            movies = try decoder.decode(Set<Movie>.self, from: data)
        } catch {
            print("Failed to read data from file: \(error)")
        }
    }

    private func saveDataToFile() {
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("bookmarkedMovies.json") else {
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save data to file: \(error)")
        }
    }
}
