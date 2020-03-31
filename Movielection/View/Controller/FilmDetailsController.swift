//
//  FilmDetailsController.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class FilmDetailsController: UIViewController {
    let vm: FilmDetailsViewModel = FilmDetailsViewModel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsis: UITextView!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var playTrailer: UIButton!
    @IBOutlet weak var marker: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func addAction(_ sender: Any) {
        vm.add(self)
    }
    
    @IBAction func playTrailerAction(_ sender: Any) {
        vm.play(self)
    }

    @IBAction func markerAction(_ sender: Any) {
        
    }
}

//MARK: View Lifecycle

extension FilmDetailsController {
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.setUp(vc: self)
    }
}

//MARK: - Imperative methods

extension FilmDetailsController {
    func setImage(_ value: Bool) -> UIImage? {
        guard let trash = UIImage(systemName: "trash.fill"), let plus = UIImage(systemName: "plus") else {
            return nil
        }
        return value ? trash : plus
    }
}

//MARK: - Collection view data source

extension FilmDetailsController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.moviesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.Identifier, for: indexPath) as? MovieCell else {
          //Something went wrong with the identifier.
          return UICollectionViewCell()
        }
        cell.title.text = vm.moviesList[indexPath.row].title
        cell.img.image = vm.moviesList[indexPath.row].img
        return cell
    }
}

// MARK: - Collection view FlowLayout

extension FilmDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/2), height: collectionView.frame.size.height)
    }
}
