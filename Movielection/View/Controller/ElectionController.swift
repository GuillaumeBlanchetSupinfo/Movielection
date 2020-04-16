//
//  ElectionController.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class ElectionController: UIViewController {
    let vm : ElectionViewModel = ElectionViewModel()
    var alert: UIAlertController!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var randomMovie: UIButton!
    @IBAction func randomAction(_ sender: Any) {
        vm.showAlert(vc: self)
    }
    @IBAction func qrAction(_ sender: Any) {
        guard let qrvc = storyboard?.instantiateViewController(identifier: "QRVC") as? QRController else {
            return
        }
        vm.QRAction(self, qrvc)
    }
}

//MARK: View Lifecycle

extension ElectionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.frame.size = self.view.frame.size
    }
}

//MARK: - Imperative methods

extension ElectionController{
    
}

//MARK: - Collection view data source

extension ElectionController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.selectedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.Identifier, for: indexPath) as? MovieCell else {
          //Something went wrong with the identifier.
          return UICollectionViewCell()
        }
        cell.title.text = vm.selectedMovies[indexPath.row].title
        cell.img.image = vm.selectedMovies[indexPath.row].img
        return cell
    }
}

// MARK: - Collection view delegate

extension ElectionController : UICollectionViewDelegate {
}

// MARK: - Collection view FlowLayout

extension ElectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/2), height: (((self.view.frame.size.width/2)/2)*3))
    }
}

// MARK: - Alert

extension ElectionController {
    func playLoader() {
        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    func dismissLoader() {
        alert.dismiss(animated: true, completion: nil)
    }
}
