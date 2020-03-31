//
//  RoundShadowView.swift
//  Movielection
//
//  Created by DotVision DotVision on 06/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor

    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
