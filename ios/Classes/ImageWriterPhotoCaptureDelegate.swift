//
//  ImageWriterPhotoCaptureDelegate.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/9/18.
//

import Flutter
import Foundation
import AVFoundation
import VideoToolbox

@available(iOS 11.0, *)
class ImageWriterPhotoCaptureDelegateFactory {
    let basePath : String
    init(basePath : String) {
        self.basePath = basePath
    }
    func createPhotoCaptureDelegate(capturePhotoSettingsId : Int64, capturePhotoEventChannelController : CapturePhotoEventChannelController) -> ImageWriterPhotoCaptureDelegate {
        let sampleBufferImageWriter : PhotoImageWriter = createSampleBufferImageWriter(id: capturePhotoSettingsId)
        return ImageWriterPhotoCaptureDelegate(sampleBufferImageWriter, capturePhotoEventChannelController: capturePhotoEventChannelController)
    }
    
    private func createSampleBufferImageWriter(id : Int64) -> PhotoImageWriter {
        let sampleBufferImageWriter = PhotoImageWriter(basePath: basePath)
        return sampleBufferImageWriter
        
    }
    
}
//
//@available(iOS 11.0, *)
//class ImageWriterCapturePhotoCaptureDelegate : NSObject, AVCapturePhotoCaptureDelegate {
//    //    initialize(eventChannel, imageWriter) {
//    //    }
//    func photoOutput(_ output: AVCapturePhotoOutput,
//                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
//                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                     resolvedSettings: AVCaptureResolvedPhotoSettings,
//                     bracketSettings: AVCaptureBracketedStillImageSettings?,
//                     error: Error?) {
//        //        imageWriter.writePhoto(photoSampleBuffer)
//        //        imageWriter.writePreviewPhoto(previewPhotoSampleBuffer)
//
//        //        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(outputSampleBuffer!)!
//        //        let ciImage = CIImage(cvImageBuffer: imageBuffer)
//        //        let croppedImage = ciImage.cropped(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))
//        //
//        //        let offsetCroppedImage = croppedImage.transformed(by: CGAffineTransform.init(translationX: 0.0, y: -840.0))
//        //        let scaledCroppedImage = offsetCroppedImage.transformed(by: CGAffineTransform.init(scaleX: 1200.0/1080.0, y: 1200.0/1080.0))
//        //        if pixelBuffer == nil {
//        //            CVPixelBufferCreate(kCFAllocatorDefault, 1200, 1200, kCVPixelFormatType_32BGRA, nil, &(self.pixelBuffer))
//        //        }
//        //
//
//        //        let context:CIContext = CIContext.init(options: nil)
//        //        context.render(scaledCroppedImage, to: pixelBuffer!)
//        //        let outFileUrl = URL.init(fileURLWithPath: "test.png")
//        //        context.writePNGRepresentation(of:  to: , format: <#T##CIFormat#>, colorSpace: <#T##CGColorSpace#>, options: <#T##[AnyHashable : Any]#>)
//        //        return Unmanaged.passRetained(pixelBuffer!)
//        //        return Unmanaged.passRetained(imageBuffer)
//
//    }
//}

@available(iOS 11.0, *)
class ImageWriterPhotoCaptureDelegate : NSObject, AVCapturePhotoCaptureDelegate {
    let imageWriter : PhotoImageWriter
    let capturePhotoEventChannelController : CapturePhotoEventChannelController
    init(_ imageWriter : PhotoImageWriter, capturePhotoEventChannelController : CapturePhotoEventChannelController ){
        self.imageWriter = imageWriter
        self.capturePhotoEventChannelController = capturePhotoEventChannelController
        super.init()
    }
    
    //    public func photoOutput(_ output: AVCapturePhotoOutput,
    //                            didFinishProcessingPhoto photo: AVCapturePhoto,
    //                            error: Error?) {
    //        imageWriter.writeCapturePhoto(photo)
    //        photo.photoCount
    //        capturePhotoEventChannelController.photoOutput()
    //        capturePhotoEventChannelController.close()
    //    }
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        if photoSampleBuffer != nil {
            print ("photosamplebuffer exists")
        } else {
            print("nil")
        }
        if previewPhotoSampleBuffer != nil {
            print ("previewPhotoSampleBuffer exists")
        }else {
            print("nil")
        }
        
        imageWriter.writeSampleBuffer(sampleBuffer: photoSampleBuffer.unsafelyUnwrapped)
        capturePhotoEventChannelController.photoOutput(photoOutputPath: "")
        capturePhotoEventChannelController.close()
    }
    
    //    func photoOutput(_ output: AVCapturePhotoOutput,
    //                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
    //                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
    //                     resolvedSettings: AVCaptureResolvedPhotoSettings,
    //                     bracketSettings: AVCaptureBracketedStillImageSettings?,
    //                     error: Error?) {
    //        print("hello !!!!!!!!!!!!")
    //    }
    
    //    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    //        print("hello !!!!!!!!!!!!")
    //    }
    public func photoOutput(_ output: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photo: AVCapturePhoto,
                            error: Error?) {
        print("hello !!!!!!!!!!!!")
        let photoUrl = imageWriter.writeCapturePhoto(photo)!
        capturePhotoEventChannelController.photoOutput(photoOutputPath: photoUrl.absoluteString)
        capturePhotoEventChannelController.close()
    }
    
}


