//
//  PhotoEventStreamController.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/9/18.
//

import Foundation


class CapturePhotoEventChannelController {
    let flutterEventChannel : FlutterEventChannel
    let flutterStreamController : FlutterStreamController

    init(flutterEventChannel : FlutterEventChannel, flutterStreamController : FlutterStreamController) {
        self.flutterEventChannel = flutterEventChannel
        self.flutterStreamController = flutterStreamController
    }
    
    func connectStreamHandler() {
        flutterEventChannel.setStreamHandler(flutterStreamController)
    }
    
    func willBeginCapture() {
        
    }
    
    func willCapturePhoto() {
        
    }
    
    func didCapturePhoto() {
        
    }
    
    func didFinishCapture() {
        
    }
    
    func didFinishProcessing() {
        
    }
    
    func photoOutput(photoOutputPath : String) {
        flutterStreamController.add(["photoOutput": true, "photoOutputPath": photoOutputPath])
    }
    
    func close() {
        flutterStreamController.close()
    }
    
    func dispose() {
        flutterEventChannel.setStreamHandler(nil)
    }

}

class FlutterStreamController : NSObject, FlutterStreamHandler {
    var flutterEventSink : FlutterEventSink? = nil

    func add(_ event : Dictionary<String, Any>) {
        flutterEventSink?(event)
    }
    func error(_ code : String, message: String?, details: Any?) {
        flutterEventSink?(FlutterError(code: code, message: message, details: details))
    }
    func close() {
        flutterEventSink?(FlutterEndOfEventStream)
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterEventSink = nil
        return nil
    }
}
