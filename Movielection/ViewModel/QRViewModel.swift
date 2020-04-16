//
//  QRViewModel.swift
//  Movielection
//
//  Created by DotVision DotVision on 19/03/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import Foundation
import AVFoundation

class QRViewModel {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var observers : [QRDelegate] = [QRDelegate]()

    init() {}
    
    func setUp(_ vc: QRController) {
        vc.view.backgroundColor = .black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed(vc)
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(vc, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed(vc)
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = vc.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        vc.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func start() {
        if let session = captureSession, !session.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stop() {
        if let session = captureSession, session.isRunning {
            captureSession.stopRunning()
        }
    }

    func found(_ vc: QRController, code: String) {
        for observer in observers {
            observer.result(code.components(separatedBy: ","))
        }
        vc.navigationController?.popViewController(animated: true)
    }

    func failed(_ vc: QRController) {
        Utils().showError(parentViewController: vc, value: "Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSession = nil
    }
    
    func registerListener(observer : QRDelegate) {
        observers.append(observer)
    }
}
