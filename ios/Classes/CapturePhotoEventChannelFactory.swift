//
//  CapturePhotoEventChannel.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/10/18.
//

import Flutter
import Foundation


class CapturePhotoEventChannelFactory {
    let flutterBinaryMessenger : FlutterBinaryMessenger
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
        self.flutterBinaryMessenger = flutterBinaryMessenger
    }
    var captureDelegateEventChannels : Dictionary<Int64, FlutterEventChannel> = [:]
    func createCapturePhotoEventChannel(_ capturePhotoSettingsId : Int64) -> FlutterEventChannel {
        let eventChannelName : String = "bestow.io/capture_photo_events/\(capturePhotoSettingsId)"
        let eventChannel : FlutterEventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: self.flutterBinaryMessenger)
        
        captureDelegateEventChannels[capturePhotoSettingsId] = eventChannel
        return eventChannel
    }
}

