//
//  FilmsViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

class FilmsViewModel : FilmDelegate {
    var selectedMovie: Movie!
    var moviesList: [Movie] = []
    var moviesSelected: [Movie] = []
    var fetchingMore = false
    var page: Int = 0
    var maxPage: Int = 1
    var searchText: String? = nil

    init() {}

    func setUp(vc: FilmsController) {
        vc.clear(navigationController: vc.navigationController)
        setUpRefreshControl(vc: vc)
        vc.collection.frame.size = vc.view.frame.size
        vc.createSearchBar()
        vc.collectionRegister()
        discover { (movies) in
            self.moviesList.append(contentsOf: movies)
            vc.collection.reloadData()
        }
    }

    func setUpRefreshControl(vc: FilmsController) {
        vc.collection.refreshControl = vc.refreshControl
        vc.refreshControl.tintColor = .systemIndigo
        vc.refreshControl.addTarget(vc, action: #selector(vc.refresh(_:)), for: .valueChanged)
    }
    
    func setUpCell(cell : MovieCell, index: Int) {
        cell.title.text = moviesList[index].title
        cell.img.image = moviesList[index].img
    }

    func transferData(vc: FilmController) -> FilmController {
        for m in moviesSelected where m.id == selectedMovie.id {
            selectedMovie.selected = true
        }
        vc.vm.movie = selectedMovie
        vc.vm.vc = vc
        vc.vm.moviesList = moviesList.filter { $0.title != selectedMovie.title }
        vc.vm.registerListener(observer: self)
        return vc
    }

    func refresh(vc: FilmsController){
        page = 0
        maxPage = 0
        searchText = nil
        vc.refreshControl.beginRefreshing()
        discover { (movies) in
            self.moviesList = []
            self.moviesList.append(contentsOf: movies)
            vc.collection.reloadData()
            vc.refreshControl.endRefreshing()
        }
    }

    func search(query: String, callback: @escaping ([Movie]) -> Void) {
        searchText = query
        page = page+1
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Api.shared.searchMovies(query: query, language: Utils.getLanguages(), page: page, adult: false, year: nil, callback: { movies, maxPage  in
            self.maxPage = maxPage
            DispatchQueue.main.async {
                let group = DispatchGroup()
                for movie in movies {
                    group.enter()
                    Api.shared.getPoster(query: movie.imgURI) { (img) in
                        movie.img = img
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    callback(movies)
                }
            }
        })
    }

    func discover(callback: @escaping ([Movie]) -> Void) {
        page = page+1
        Api.shared.discoverMovies(language: Utils.getLanguages(), page: page, adult: false, callback: { movies, maxPage  in
            self.maxPage = maxPage
            DispatchQueue.main.async {
                let group = DispatchGroup()
                for movie in movies {
                    group.enter()
                    Api.shared.getPoster(query: movie.imgURI) { (img) in
                        movie.img = img
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    callback(movies)
                }
            }
        })
    }

    func beginBatchFetch(vc: FilmsController) {
        fetchingMore = true
        if page <= maxPage {
            if let query = searchText {
                search(query: query) { (movies) in
                    self.moviesList.append(contentsOf: movies)
                    vc.collection.reloadData()
                    self.fetchingMore = false
                }
            } else {
                discover { (movies) in
                    self.moviesList.append(contentsOf: movies)
                    vc.collection.reloadData()
                    self.fetchingMore = false
                }
            }
        } else {
            fetchingMore = false
        }
    }

    func showSearchBar(vc: FilmsController) {
        if vc.navigationItem.titleView != vc.searchBar {
            vc.openSearchBar()
        }else{
            vc.closeSearchBar()
        }
    }

    func searchAction(vc: FilmsController, status: Bool?) {
        vc.searchBar.endEditing(true)
        if let status = status {
            if status {
                if let text = vc.searchBar.text {
                    page = 0
                    maxPage = 0
                    vc.playLoader()
                    vc.collection.setContentOffset(.zero, animated: true)
                    search(query: text) { (movies) in
                        self.moviesList = []
                        self.moviesList.append(contentsOf: movies)
                        vc.collection.reloadData()
                        vc.dismissLoader()
                    }
                    vc.closeSearchBar()
                }
            } else {
                vc.closeSearchBar()
            }
        }
    }

    func add(_ movie: Movie) {
        moviesSelected.append(movie)
    }

    func delete(_ movie: Movie) {
        moviesSelected = moviesSelected.filter { $0.title != movie.title  }
    }
}
