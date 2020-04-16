//
//  Api.swift
//  Movielection
//
//  Created by DotVision DotVision on 27/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation
import UIKit

class Api {
    private let API_KEY = "241a6f64741ccab6f49ae2b19d5fe883"
    private let discoverMoviesUrl = "https://api.themoviedb.org/3/discover/movie?"
    private let searchMoviesUrl = "https://api.themoviedb.org/3/search/movie?"
    private let posterPathUrl = "https://image.tmdb.org/t/p/w500"
    private let trailerUrl = "https://api.themoviedb.org/3/movie/$XXX$/videos?"
    private let movieUrl = "https://api.themoviedb.org/3/movie/"
    static var shared = Api()
}

// MARK: REQUEST

extension Api {

    func searchMovies(query: String, language: String, page: Int, adult: Bool, year: Int?, callback: @escaping(_ movies: [Movie], _ maxPage: Int, _ error: String? ) -> Void) {
        var movies : [Movie] = []
        var maxPage: Int = 0
        guard let url = URL(string: searchMoviesUrl+"api_key=\(API_KEY)&language=\(language)&query=\(query)&page=\(page)&include_adult=\(adult)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any],
                       let results = dictionary["results"] as? Array<Any>,
                       let total_pages = dictionary["total_pages"] as? Int {
                        maxPage = total_pages
                        for element in results {
                            if let info = element as? [String: Any] {
                                if let movie = self.parsingData(data: info) {
                                    movies.append(movie)
                                }
                            }
                        }
                    }
                }
            }
            callback(movies, maxPage, error?.localizedDescription)
        }
        task.resume()
    }
    
    func discoverMovies(language: String, page: Int, adult: Bool, callback: @escaping(_ movies: [Movie], _ maxPage: Int, _ error: String?) -> Void) {
        var movies: [Movie] = []
        var maxPage: Int = 0
        guard let url = URL(string: discoverMoviesUrl+"api_key=\(API_KEY)&language=\(language)&sort_by=popularity.desc&page=\(page)&include_adult=\(adult)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any],
                       let results = dictionary["results"] as? Array<Any>,
                       let total_pages = dictionary["total_pages"] as? Int {
                        maxPage = total_pages
                        for element in results {
                            if let info = element as? [String: Any] {
                                if let movie = self.parsingData(data: info) {
                                    movies.append(movie)
                                }
                            }
                        }
                    }
                }
            }
            callback(movies, maxPage, error?.localizedDescription)
        }
        task.resume()
    }

    func getPoster(query: String, callback: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: posterPathUrl+query) else {
            callback(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let image = UIImage(data: data) {
                    callback(image)
            } else {
                callback(nil)
            }
        }
        task.resume()
    }

    func getTrailer(id: Int, language: String, callback: @escaping(String) -> Void) {
        let trailer = trailerUrl.replacingOccurrences(of: "$XXX$", with: "\(id)", options: .literal, range: nil)
        guard let url = URL(string: trailer+"api_key=\(API_KEY)&language=\(language)") else {
            callback("")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data,
               error == nil,
               let response = response as? HTTPURLResponse, response.statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dictionary = json as? [String: Any],
               let results = dictionary["results"] as? Array<Any>,
               let info = results.first as? [String: Any] {
                guard let id = info["key"] as? String else {
                    callback("")
                    return
                }
                callback("https://www.youtube.com/embed/\(id)")
            } else {
                callback("")
            }
        }
        task.resume()
    }

    func getMovie(id: Int, language: String, callback: @escaping(_ movies: [Movie], _ error: String?) -> Void) {
        var movies: [Movie] = []
        guard let url = URL(string: movieUrl+"\(id)?api_key=\(API_KEY)&language=\(language)") else {
            callback(movies, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any] {
                        if let movie = self.parsingData(data: dictionary) {
                            movies.append(movie)
                        }
                    }
                }
            }
            callback(movies, error?.localizedDescription)
        }
        task.resume()
    }

    private func parsingData(data:[String: Any]) -> Movie?{
        guard let id = data["id"] as? Int,
              let title = data["title"] as? String,
              let imgURI = data["poster_path"] as? String,
              let overview = data["overview"] as? String else {
            return nil
        }
        return Movie(id: id, title: title, imgURI: imgURI, overview: overview, img: nil)
    }
}
