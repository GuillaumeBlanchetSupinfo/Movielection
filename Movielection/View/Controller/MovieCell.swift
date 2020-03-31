//
//  MovieCell.swift
//  Movielection
//
//  Created by DotVision DotVision on 29/02/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let Identifier = "MovieCell"
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
