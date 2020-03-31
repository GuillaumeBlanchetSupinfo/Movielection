//
//  ElectionViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

class ElectionViewModel {
    var selectedMovies: [Movie] = []
    let utils = Utils()
    
    func election(movies: [Movie]) -> Movie? {
        guard let movie = movies.randomElement() else {
            return nil
        }
        return movie
    }

    func showAlert(vc: ElectionController) {
        let button = AlertButton(title: "OK", action: {
            // Faire une Action
        }, titleColor: nil, backgroundColor: nil)
        let alertPayload = AlertPayload(title: nil, titleColor: nil, message: nil, messageColor: nil, buttons: [button], backgroundColor: nil)
        if let movie = election(movies: selectedMovies) {
            utils.showAlert(payload: alertPayload, parentViewController: vc, theMovie: movie)
        } else {
            return // ici rajouter une erreur.
        }
    }
}
