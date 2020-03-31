//
//  TrailerController.swift
//  Movielection
//
//  Created by DotVision DotVision on 18/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit
import WebKit

class TrailerController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    let vm : TrailerViewModel = TrailerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.loadTrailer(self)
    }
}
