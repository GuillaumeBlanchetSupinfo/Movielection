//
//  QRController.swift
//  Movielection
//
//  Created by DotVision DotVision on 19/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import UIKit
import AVFoundation

class QRController: UIViewController {

    let vm = QRViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension QRController : AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return vm.cameraWithPosition(position)
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        vm.readMetadata(metadataObjects)
    }
}
