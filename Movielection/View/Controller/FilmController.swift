//
//  FilmController.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class FilmController: UIViewController {
    let vm: FilmViewModel = FilmViewModel()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var heightScroll: NSLayoutConstraint!
    @IBOutlet weak var scroll: UIScrollView!
}

//MARK: View Lifecycle

extension FilmController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        scroll.frame.size.width = self.view.frame.size.width
        scroll.frame.size.height = self.view.frame.size.height - (self.view.frame.size.height * 0.115)
        heightScroll.constant = scroll.frame.size.height + (scroll.frame.size.height * 0.406)
        img.image = vm.movie.img
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            if let filmDetailsController = segue.destination as? FilmDetailsController {
                filmDetailsController.vm.movie = vm.movie
                filmDetailsController.vm.moviesList = vm.moviesList
                filmDetailsController.vm.registerListener(observer: vm)
            }
        }
    }
}

//MARK: - Imperative methods

extension FilmController {

}
