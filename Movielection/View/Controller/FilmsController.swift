//
//  FilmsController.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class FilmsController: UIViewController  {
    let vm : FilmsViewModel = FilmsViewModel()
    let searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()
    var loadingView: LoadCollection!
    var alert: UIAlertController!
    let loadingReusableNib = UINib(nibName: "LoadCollection", bundle: nil)
    @IBOutlet weak var MoviesSelectedListButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var collection: UICollectionView!
    @IBAction func search(_ sender: Any) {
        vm.showSearchBar(vc: self)
    }
}

//MARK: View Lifecycle

extension FilmsController {
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.setUp(vc: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ElectionController {
            vc.vm.selectedMovies = vm.moviesSelected
        }
    }
}

//MARK: - Imperative methods

extension FilmsController{
    @objc func refresh(_ sender: Any){
        vm.refresh(vc: self)
    }
    
    //
    func touchBottom(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height && !vm.fetchingMore {
            vm.beginBatchFetch(vc: self)
        }
    }
    //
}

//MARK: - Collection view data source

extension FilmsController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.moviesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.Identifier, for: indexPath) as? MovieCell else {
          //Something went wrong with the identifier.
          return UICollectionViewCell()
        }
        vm.setUpCell(cell: cell, index: indexPath.row)
        return cell
    }
}

// MARK: - Collection view delegate

extension FilmsController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.selectedMovie = vm.moviesList[indexPath.row]
        if let filmController = storyboard?.instantiateViewController(identifier: "filmController") as? FilmController {
            self.show(vm.transferData(vc: filmController), sender: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        touchBottom(scrollView: scrollView)
    }
}

// MARK: - Collection view FlowLayout

extension FilmsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width/2), height: (((self.view.frame.size.width/2)/2)*3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if vm.fetchingMore {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            if let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as? LoadCollection {
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.loader.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.loader.stopAnimating()
        }
    }

    func collectionRegister() {
        collection.register(loadingReusableNib,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: "loadingresuableviewid")
    }

}

// MARK: - Search

extension FilmsController: UISearchBarDelegate {

    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = NSLocalizedString("searchEvent", comment: "")
        searchBar.barTintColor = .systemIndigo
        searchBar.returnKeyType = .search
        searchBar.tintColor = .systemPurple
        searchBar.delegate = self
        searchBar.alpha = 0
        searchBar.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -20, 0)
        UIView.animate(withDuration: 0.35){
            self.searchBar.alpha = 1
            self.searchBar.layer.transform = CATransform3DIdentity
        }
    }

    func setButtonSearch(search: Bool) -> UIButton {
        let searchButton : UIButton = UIButton(type: .custom)
        let image = search ? UIImage(systemName: "magnifyingglass") : UIImage(systemName: "arrow.uturn.left")
        searchButton.setImage(image, for: .normal)
        searchButton.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        return searchButton
    }

    func openSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: setButtonSearch(search: false))
        searchBar.alpha = 0
        searchBar.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -20, 0)
        UIView.animate(withDuration: 0.35){
            self.searchBar.alpha = 1
            self.searchBar.layer.transform = CATransform3DIdentity
        }
        searchBar.becomeFirstResponder()
    }

    func closeSearchBar() {
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: setButtonSearch(search: true))
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        vm.searchAction(vc: self, status: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.searchAction(vc: self, status: false)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        vm.searchAction(vc: self, status: true)
    }
}

// MARK: - Alert
extension FilmsController {
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

