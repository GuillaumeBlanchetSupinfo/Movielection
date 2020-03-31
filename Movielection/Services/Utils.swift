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
        if (payload.buttons.count == 1) {
            customAlertController = self.instantiateViewController(storyboardName: "Main", viewControllerIdentifier: "onAlert") as? ElectedController
            customAlertController.vm.movie = theMovie
        } else {
            return
        }
        customAlertController?.payload = payload
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(customAlertController, forKey: "contentViewController")
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
