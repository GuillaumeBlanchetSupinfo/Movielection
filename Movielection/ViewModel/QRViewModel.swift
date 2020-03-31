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
    
    init() {}
    
    func setUp(vc: QRController) {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
                              
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
                   
            // Initialize the captureSession object
            let captureSession =  AVCaptureSession()
                   
            // Set the input device on the capture session
            captureSession.addInput(input)
                   
            // Get an instance of ACCapturePhotoOutput class
            let capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput.isHighResolutionCaptureEnabled = true
                   
            // Set the output on the capture session
            captureSession.addOutput(capturePhotoOutput)
            captureSession.sessionPreset = .high
                   
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
                   
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(vc, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                   
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = vc.view.layer.bounds

            //start video capture
            captureSession.startRunning()
                   
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
    }

    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }

    func readMetadata(_ metadataObjects: [AVMetadataObject]) {
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                }
            }
        }
    }
}
