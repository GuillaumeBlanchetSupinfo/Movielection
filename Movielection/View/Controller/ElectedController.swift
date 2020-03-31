//
//  ElectedController.swift
//  Movielection
//
//  Created by DotVision DotVision on 28/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

struct AlertButton {
    var title: String!
    var action: (() -> Swift.Void)? = nil
    var titleColor: UIColor?
    var backgroundColor: UIColor?
}

struct AlertPayload {
    var title: String!
    var titleColor: UIColor?
    var message: String!
    var messageColor: UIColor?
    var buttons: [AlertButton]!
    var backgroundColor: UIColor?
}

class ElectedController: UIViewController {
    var payload: AlertPayload!;
    let vm: ElectedViewModel = ElectedViewModel()
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = vm.movie.title
        img.image = vm.movie.img
        if (payload.buttons.count == 1) {
            createButton(uiButton: okButton, alertButton: payload.buttons[0])
        }
    }

    //MARK: Create custom alert buttons
    private func createButton(uiButton: UIButton, alertButton: AlertButton) {
        uiButton.setTitle(alertButton.title, for: .normal);
        if (alertButton.titleColor != nil) {
            uiButton.setTitleColor(alertButton.titleColor, for: .normal);
        }
        if (alertButton.backgroundColor != nil) {
            uiButton.backgroundColor = alertButton.backgroundColor;
        }
    }

    //MARK: UIButton Actions
    @IBAction func okTapped(_ sender: Any) {
        parent?.dismiss(animated: false, completion: nil)
        payload.buttons.first?.action?()
    }
}
