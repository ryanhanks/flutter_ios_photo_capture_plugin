import Flutter
import UIKit
import AVFoundation

@available(iOS 11.0, *)
public class SwiftPhotoCapturePlugin: NSObject, FlutterPlugin {
    //    static var flutterPluginRegistrar : FlutterPluginRegistrar? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "bestow.io/photo_capture_session", binaryMessenger: registrar.messenger())
        let photoCaptureSessionConfiguration : PhotoCaptureSessionConfiguration = PhotoCaptureSessionConfiguration(flutterTextureRegistry: registrar.textures(), flutterBinaryMessenger: registrar.messenger())
        let photoCaptureSession : PhotoCaptureSession = PhotoCaptureSession(configuration: photoCaptureSessionConfiguration)
        let photoCaptureSessionMethodCallDelegate : PhotoCaptureSessionMethodCallDelegate = PhotoCaptureSessionMethodCallDelegate(flutterPluginRegistrar: registrar, photoCaptureSession: photoCaptureSession)
        registrar.addMethodCallDelegate(photoCaptureSessionMethodCallDelegate, channel: channel)
    }
}


@available(iOS 11.0, *)
class PhotoCaptureSessionMethodCallDelegate : NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) { raise(1) }
    
    let flutterPluginRegistrar : FlutterPluginRegistrar
    let photoCaptureSession : PhotoCaptureSession
    var captureDelegateEventChannels : Dictionary<Int, FlutterEventChannel> = [:]
    
    init(flutterPluginRegistrar : FlutterPluginRegistrar, photoCaptureSession : PhotoCaptureSession) {
        self.flutterPluginRegistrar = flutterPluginRegistrar
        self.photoCaptureSession = photoCaptureSession
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            let arguments = call.arguments as? Dictionary<String, Any>
            let imageDirectoryPath : String = arguments!["imageDirectoryPath"] as! String
            photoCaptureSession.configuration.setImageDirectoryPath(imageDirectoryPath)
            result(true)
        case "getSession":
            let textureId : Int64 = photoCaptureSession.configuration.textureId;
            result(["textureId": textureId]);
        case "startSession":
            print("starting session")
            photoCaptureSession.startRunning()
            print("session started")
            result(true)
        case "preparePhotoCapture":
            // create delegate
            // create event channel for delegate
            // set stream handler on event channel to delegate
            
            let capturePhotoSettingsId = photoCaptureSession.preparePhotoCapture()
            result(["photoCaptureSettingsId": capturePhotoSettingsId])
        case "capture":
            let arguments = call.arguments as? Dictionary<String, Any>
            let capturePhotoSettingsId : Int64 = arguments!["photoCaptureSettingsId"]! as! Int64
            //            let capturePhotoSettings = capturePhotoSettingsById[capturePhotoSettingsId]
            photoCaptureSession.capturePhoto(capturePhotoSettingsId)
            //            let r : Dictionary<String, Any> = ["captureId:": captureDelegateId]
            result(true)
        case "disposePhotoCapture":
            // set streamhandler on event channel to nil
            // unset reference to delegate in dictionary
            // unset reference to event channel in dictionary
            let arguments = call.arguments as? Dictionary<String, Any>
            let photoCaptureSettingsId : Int64 = arguments!["photoCaptureSettingsId"]! as! Int64
            photoCaptureSession.disposePhotoCapture(photoCaptureSettingsId)
            result(true)
        case "stopSession":
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

