//
//  QRService.swift
//  Movielection
//
//  Created by DotVision DotVision on 19/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation
import UIKit

class QRServices {
    static func createQRCode(query: String) -> UIImage? {
        let data = query.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage)
        return processedImage
    }
}
