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
    var vm = QRViewModel()
}

//MARK: View Lifecycle

extension QRController {
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.setUp(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vm.stop()
    }
}

//MARK: - Style methods

extension QRController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - Capture Metadata Output

extension QRController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        vm.captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            vm.found(self, code: stringValue)
        }

        dismiss(animated: true)
    }
}


