//
//  FilmViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation
//import UIKit

class FilmViewModel: FilmDetailsDelegate {

    var movie: Movie!
    var moviesList: [Movie] = []
    var observers : [FilmDelegate] = [FilmDelegate]()
    var vc : FilmController!

    init() {}

    func registerListener(observer : FilmDelegate) {
        observers.append(observer)
    }

    func add(_ movie: Movie) {
        for observer in observers {
            observer.add(movie)
        }
    }

    func delete(_ movie: Movie) {
        for observer in observers {
            observer.delete(movie)
        }
    }

    func trailer(_ trailer: String) {
        presentVideo(trailer)
    }

    func presentVideo(_ url: String) {
        if let trailerController = vc.storyboard?.instantiateViewController(identifier: "trailerController") as? TrailerController {
            vc.show(transferData(vc: trailerController, url: url), sender: nil)
        }
    }

    func transferData(vc: TrailerController, url: String) -> TrailerController {
        vc.vm.url = url
        return vc
    }
}
