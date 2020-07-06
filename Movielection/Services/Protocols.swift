//
//  Protocols.swift
//  Movielection
//
//  Created by DotVision DotVision on 12/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

protocol FilmDetailsDelegate {
    func add(_ movie: Movie)
    func delete(_ movie: Movie)
    func trailer(_ trailer: String)
}

protocol FilmDelegate {
    func add(_ movie: Movie)
    func delete(_ movie: Movie)
}

protocol ElectionDelegate {
    func delete(_ movie: Movie)
}

protocol FilmFromQRDelegate {
    func added()
}

protocol QRDelegate {
    func result(_ value: [String])
}
