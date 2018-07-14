//
//  Configuration.swift
//  av_capture
//
//  Created by Ryan Hanks on 4/20/18.
//
import Flutter
import Foundation
import AVFoundation
import VideoToolbox
@available(iOS 11.0, *)
class PhotoCaptureSessionConfiguration {
    let flutterTextureRegistry : FlutterTextureRegistry
    let flutterBinaryMessenger : FlutterBinaryMessenger
    
    init(flutterTextureRegistry : FlutterTextureRegistry, flutterBinaryMessenger : FlutterBinaryMessenger) {
        self.flutterTextureRegistry = flutterTextureRegistry
        self.flutterBinaryMessenger = flutterBinaryMessenger
    }

    private var _imageDirectoryPath : String? = nil

    var imageDirectoryPath : String? {
        return _imageDirectoryPath
    }
    
    func setImageDirectoryPath(_ imageDirectoryPath : String) {
        self._imageDirectoryPath = imageDirectoryPath
    }

    private var _captureSession : AVCaptureSession? = nil
    var captureSession : AVCaptureSession {
        if self._captureSession != nil { return self._captureSession! }
        self._captureSession = AVCaptureSession()
        self._captureSession!.beginConfiguration()
        _captureSession!.automaticallyConfiguresCaptureDeviceForWideColor = false
        self._captureSession!.sessionPreset = AVCaptureSession.Preset.high
        self._captureSession!.addInputWithNoConnections(self.captureInput)
        self._captureSession!.addOutputWithNoConnections(self.captureVideoDataOutput)
        self._captureSession!.add(self.captureConnection)
        self._captureSession!.addOutput(capturePhotoOutput)
        self._captureSession!.commitConfiguration()
        return self._captureSession!
    }
    
    private var _captureConnection : AVCaptureConnection? = nil
    var captureConnection : AVCaptureConnection {
        if self._captureConnection != nil { return self._captureConnection! }
        self._captureConnection = AVCaptureConnection(inputPorts: self.captureInput.ports, output: self.captureVideoDataOutput)
        self._captureConnection!.videoOrientation = AVCaptureVideoOrientation.portrait
        return self._captureConnection!
    }
    
    private var _captureInput : AVCaptureDeviceInput? = nil
    var captureInput : AVCaptureDeviceInput {
        if self._captureInput != nil { return self._captureInput! }
        try! self._captureInput = AVCaptureDeviceInput(device: self.captureDevice)
        return self._captureInput!
    }
    
    private var _captureDevice : AVCaptureDevice? = nil
    var captureDevice : AVCaptureDevice {
        if self._captureDevice != nil { return self._captureDevice! }
        let discoverySession : AVCaptureDevice.DiscoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        print(discoverySession.devices)
        print(discoverySession.devices.count)
        self._captureDevice = discoverySession.devices.first!
        return self._captureDevice!
    }
    
    private var _captureVideoDataOutput : AVCaptureVideoDataOutput? = nil
    var captureVideoDataOutput : AVCaptureVideoDataOutput {
        if self._captureVideoDataOutput != nil { return self._captureVideoDataOutput! }
        self._captureVideoDataOutput = AVCaptureVideoDataOutput()
        self._captureVideoDataOutput!.alwaysDiscardsLateVideoFrames = true
        self._captureVideoDataOutput!.setSampleBufferDelegate(self.outputSampleBufferDelegate, queue: DispatchQueue.main)
        return self._captureVideoDataOutput!
    }
    
    let capturePhotoOutput : AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    private var _outputSampleBufferDelegate : OutputSampleBufferDelegate? = nil
    var outputSampleBufferDelegate : OutputSampleBufferDelegate {
        if self._outputSampleBufferDelegate != nil { return self._outputSampleBufferDelegate! }
        self._outputSampleBufferDelegate = OutputSampleBufferDelegate(outputSampleFlutterTexture: self.outputSampleFlutterTexture)
        return self._outputSampleBufferDelegate!
    }
    
    private var _textureId : Int64? = nil
    var textureId : Int64 {
        if self._textureId != nil { return self._textureId! }
        self.createAndRegisterOutputSampleFlutterTexture()
        return self._textureId!
    }
    
    private var _outputSampleFlutterTexture : OutputSampleFlutterTexture? = nil
    var outputSampleFlutterTexture : OutputSampleFlutterTexture {
        if self._outputSampleFlutterTexture != nil { return self._outputSampleFlutterTexture! }
        self.createAndRegisterOutputSampleFlutterTexture()
        
        return self._outputSampleFlutterTexture!
    }
    
    private func createAndRegisterOutputSampleFlutterTexture() {
        assert(self._outputSampleBufferDelegate == nil && self._textureId == nil)
        self._outputSampleFlutterTexture = OutputSampleFlutterTexture(flutterTextureRegistry: self.flutterTextureRegistry)
        self._textureId = self.flutterTextureRegistry.register(self._outputSampleFlutterTexture!)
        self._outputSampleFlutterTexture!.setTextureId(textureId: self._textureId!)
    }

    func createCapturePhotoSettings() -> AVCapturePhotoSettings {
        print(capturePhotoOutput.availableRawPhotoPixelFormatTypes)
        if let rawFormat = capturePhotoOutput.availableRawPhotoPixelFormatTypes.first {
            return AVCapturePhotoSettings(rawPixelFormatType: OSType(rawFormat))
        }
//        return AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodec])
//        return AVCapturePhotoSettings()
        return AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
//        AVCapturePhotoSettings(rawPixelFormatType: <#T##OSType#>)
    }

    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    func createPhotoCaptureDelegate(captureSettingsId : Int64, eventChannelController : CapturePhotoEventChannelController) -> AVCapturePhotoCaptureDelegate {
        return imageWriterPhotoCaptureDelegateFactory.createPhotoCaptureDelegate(capturePhotoSettingsId: captureSettingsId, capturePhotoEventChannelController: eventChannelController)
    }
    
    private var _imageWriterPhotoCaptureDelegateFactory : ImageWriterPhotoCaptureDelegateFactory?
    
    var imageWriterPhotoCaptureDelegateFactory : ImageWriterPhotoCaptureDelegateFactory {
        if _imageWriterPhotoCaptureDelegateFactory != nil { return _imageWriterPhotoCaptureDelegateFactory! }
        self._imageWriterPhotoCaptureDelegateFactory = ImageWriterPhotoCaptureDelegateFactory(basePath: imageDirectoryPath!)
        return _imageWriterPhotoCaptureDelegateFactory!
    }

    private var _capturePhotoEventChannelFactory : CapturePhotoEventChannelFactory? = nil
    var capturePhotoEventChannelFactory : CapturePhotoEventChannelFactory {
        if self._capturePhotoEventChannelFactory != nil { return self._capturePhotoEventChannelFactory! }
        self._capturePhotoEventChannelFactory = CapturePhotoEventChannelFactory(flutterBinaryMessenger: flutterBinaryMessenger)
        return self._capturePhotoEventChannelFactory!
    }
    
    func createCapturePhotoEventChannelController(_ capturePhotoSettingsId : Int64) -> CapturePhotoEventChannelController {
        let eventChannel = capturePhotoEventChannelFactory.createCapturePhotoEventChannel(capturePhotoSettingsId)
        let streamController = FlutterStreamController()
        let capturePhotoEventChannelController = CapturePhotoEventChannelController(flutterEventChannel: eventChannel, flutterStreamController: streamController)
        capturePhotoEventChannelController.connectStreamHandler()
        return capturePhotoEventChannelController
    }

}

