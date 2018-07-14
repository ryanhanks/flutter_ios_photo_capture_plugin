//
//  PhotoCaptureSession.swift
//  av_capture
//
//  Created by Ryan Hanks on 6/22/18.
//

import Foundation
import AVFoundation


@available(iOS 11.0, *)
class PhotoCaptureSession : NSObject, AVCapturePhotoCaptureDelegate {
    let configuration : PhotoCaptureSessionConfiguration

    init(configuration : PhotoCaptureSessionConfiguration) {
        self.configuration = configuration
    }
    
    func startRunning() {
        configuration.captureSession.startRunning()
    }
    
    func stopRunning() {
        configuration.captureSession.stopRunning()

    }
    
    var capturePhotoSettingsById : Dictionary<Int64, AVCapturePhotoSettings> = [:]
    var capturePhotoEventChannelControllers : Dictionary<Int64, CapturePhotoEventChannelController> = [:]

    func preparePhotoCapture() -> Int64 {
        let capturePhotoSettings = configuration.createCapturePhotoSettings()
        let capturePhotoSettingsId = capturePhotoSettings.uniqueID
        capturePhotoSettingsById[capturePhotoSettingsId] = capturePhotoSettings
        let capturePhotoEventChannelController = configuration.createCapturePhotoEventChannelController(capturePhotoSettingsId)
        capturePhotoEventChannelControllers[capturePhotoSettingsId] = capturePhotoEventChannelController
        return capturePhotoSettingsId
    }

    var photoCaptureDelegates : Dictionary<Int64, AVCapturePhotoCaptureDelegate> = [:]
    func capturePhoto(_ photoCaptureSettingsId : Int64) {
        let capturePhotoSettings = capturePhotoSettingsById[photoCaptureSettingsId]!
        let capturePhotoEventChannelController = capturePhotoEventChannelControllers[photoCaptureSettingsId]!
        let photoCaptureDelegate = configuration.createPhotoCaptureDelegate(captureSettingsId: photoCaptureSettingsId, eventChannelController: capturePhotoEventChannelController)
        photoCaptureDelegates[photoCaptureSettingsId] = photoCaptureDelegate
        configuration.capturePhotoOutput.capturePhoto(with: capturePhotoSettings, delegate: photoCaptureDelegate)
    }
    
    func disposePhotoCapture(_ photoCaptureSettingsId : Int64) {
        capturePhotoSettingsById.removeValue(forKey: photoCaptureSettingsId)
        let controller = capturePhotoEventChannelControllers.removeValue(forKey: photoCaptureSettingsId)
        controller?.dispose()
        photoCaptureDelegates.removeValue(forKey: photoCaptureSettingsId)
    }
    
}
