//
//  FilmDetailsViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

class FilmDetailsViewModel {
    var movie: Movie!
    var moviesList: [Movie] = []
    var observers : [FilmDetailsDelegate] = [FilmDetailsDelegate]()
    init() {}
    
    func setUp(vc : FilmDetailsController) {
        vc.titleLabel.text = movie.title
        vc.synopsis.text = movie.overview
        vc.synopsis.backgroundColor = .white
        vc.collection.frame.size.height = vc.view.frame.size.height/3
        vc.collection.frame.size.width = vc.view.frame.size.width
        vc.contentView.frame.size.width = vc.view.frame.size.width
        vc.contentView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        vc.activityIndicator.isHidden = true
        vc.activityIndicator.stopAnimating()
        vc.add.setImage( vc.setImage(movie.selected),
                         for: .normal)
    }

    func add(_ vc: FilmDetailsController) {
        movie.selected = !movie.selected
        vc.add.setImage(vc.setImage(movie.selected), for: .normal)
        movie.selected ? addMovie() : deleteMovie()
    }

    func play(_ vc: FilmDetailsController) {
        vc.playTrailer.isEnabled = false
        vc.playTrailer.isHidden = true
        vc.activityIndicator.startAnimating()
        vc.activityIndicator.isHidden = false
        Api.shared.getTrailer(id: movie.id, language: Utils.getLanguages()) { (url) in
            DispatchQueue.main.async {
                !url.isEmpty ? self.trailer(url: url) : Utils().showError(parentViewController: vc, value: "No trailer was found")
                vc.activityIndicator.stopAnimating()
                vc.activityIndicator.isHidden = true
                vc.playTrailer.isHidden = false
                vc.playTrailer.isEnabled = true
            }
        }
    }

    func trailer(url: String) {
        for observer in observers {
            observer.trailer(url)
        }
    }

    func addMovie() {
        for observer in observers {
            observer.add(movie)
        }
    }

    func deleteMovie() {
        for observer in observers {
            observer.delete(movie)
        }
    }

    func registerListener(observer : FilmDetailsDelegate) {
        observers.append(observer)
    }
}
