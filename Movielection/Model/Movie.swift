//
//  Movie.swift
//  Movielection
//
//  Created by DotVision DotVision on 27/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation
import UIKit

class Movie {

    let id: Int!
    let title: String!
    let imgURI: String!
    let overview: String!
    var img: UIImage!
    var selected: Bool = false

    init(id: Int, title: String, imgURI: String, overview: String, img: UIImage?) {
        self.id = id
        self.title = title
        self.imgURI = imgURI
        self.overview = overview
        self.img = img ?? UIImage(named: "NotFound")
    }
}
