//
//  ElectionViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

class ElectionViewModel: QRDelegate {

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

    func QRAction(_ vc: ElectionController, _ qrvc: QRController) {
        Utils().showQR(parentViewController: vc){ choice in
            choice ? self.generateQRCode(vc) : self.readQRCode(vc, qrvc)
        }
    }

    func generateQRCode(_ vc: ElectionController) {
        var query = ""
        for movie in selectedMovies {
            query.append(String(movie.id) + (movie.id != selectedMovies.last?.id ? "," : ""))
        }
        if query.count != 0 {
            Utils().showGeneratedQR(parentViewController: vc, qr: QRServices.createQRCode(query: query))
        } else {
            Utils().showError(parentViewController: vc, value: "You haven't movie in your list")
        }
    }

    func result(_ values: [String]) {
//        DispatchQueue.main.async {
//            for value in values {
//                if let id = Int(value) {
//                    self.getMovie(id) { movie, error in
//
//                    }
//                }
//            }
//        }
    }

    func getMovie(_ id: Int, callback: @escaping ([Movie], String?) -> Void ) {
        Api.shared.getMovie(id: id, language: Utils.getLanguages()) { (movies, error) in
            DispatchQueue.main.async {
                let group = DispatchGroup()
                for movie in movies {
                    group.enter()
                    Api.shared.getPoster(query: movie.imgURI) { (img) in
                        movie.img = img ?? movie.img
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    callback(movies, error)
                }
            }
        }
    }

    func readQRCode(_ vc: ElectionController, _ qrvc: QRController) {
        qrvc.vm.registerListener(observer: vc.vm)
        vc.show(qrvc, sender: nil)
    }
}
