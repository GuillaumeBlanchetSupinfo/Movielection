//
//  Utils.swift
//  Movielection
//
//  Created by DotVision DotVision on 04/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class Utils {
    
    func showAlert(payload: AlertPayload, parentViewController: UIViewController, theMovie: Movie) {
        var customAlertController: ElectedController!
        customAlertController = self.instantiateViewController(storyboardName: "Main", viewControllerIdentifier: "onAlert") as? ElectedController
        customAlertController.vm.movie = theMovie
        customAlertController?.payload = payload
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(customAlertController, forKey: "contentViewController")
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showError(parentViewController: UIViewController, value: String) {
        let alertController = UIAlertController(title: "Oups", message: value, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
        alertController.addAction(action)
        alertController.view.tintColor = .systemIndigo
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showQR(parentViewController: UIViewController, callback: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Crée un QR Code de vos films", style: .default) { (action:UIAlertAction) in callback(true)}
        let action2 = UIAlertAction(title: "Lire un QR Code", style: .default) { (action:UIAlertAction) in
            callback(false)}
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.view.tintColor = .systemIndigo
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showGeneratedQR(parentViewController: UIViewController, qr: UIImage?) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 250, height: 250))
        imageView.image = qr
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: alertController.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 300)
        alertController.view.addConstraint(height)
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
        alertController.addAction(action)
        alertController.view.tintColor = .systemIndigo
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
    public func instantiateViewController(storyboardName: String, viewControllerIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
    }
    
    static func getLanguages() -> String {
        let pre = Locale.preferredLanguages[0]
        if pre.contains("-") {
            return pre
        } else {
            return "en-US"
        }
    }
}
