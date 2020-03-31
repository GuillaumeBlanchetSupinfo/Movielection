//
//  TrailerViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 18/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation

class TrailerViewModel {

    var url: String!

    init() {}

    func loadTrailer(_ vc: TrailerController) {
        guard let myURL = URL(string:url) else {
            return
        }
        let myRequest = URLRequest(url: myURL)
        vc.webView.load(myRequest)
    }
}
