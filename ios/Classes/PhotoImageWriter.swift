//
//  SampleBufferImageWriter.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/9/18.
//

import Flutter
import Foundation
import AVFoundation
import VideoToolbox


@available(iOS 11.0, *)
class PhotoImageWriter {
    let basePath : String
    init(basePath : String) {
        self.basePath = basePath
    }
    //    let destinationDirectoryURL : URL

    @available(iOS 11.0, *)
    func writeSampleBuffer(sampleBuffer : CMSampleBuffer) {
          let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let croppedImage = ciImage.cropped(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))
        
        let offsetCroppedImage = croppedImage.transformed(by: CGAffineTransform.init(translationX: 0.0, y: -840.0))
        let scaledCroppedImage = offsetCroppedImage.transformed(by: CGAffineTransform.init(scaleX: 1200.0/1080.0, y: 1200.0/1080.0))
        var pixelBuffer : CVPixelBuffer? = nil
        if pixelBuffer == nil {
            CVPixelBufferCreate(kCFAllocatorDefault, 1200, 1200, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        }
        
        let context:CIContext = CIContext.init(options: nil)
        context.render(scaledCroppedImage, to: pixelBuffer!)
        let uuid = UUID().uuidString
        
        let outFileUrl = URL.init(fileURLWithPath: "\(uuid).png")
        try! context.writePNGRepresentation(of: scaledCroppedImage, to: outFileUrl, format: CIFormat(kCVPixelFormatType_32BGRA), colorSpace: CGColorSpaceModel.rgb as! CGColorSpace, options: [:])
    }
    @available(iOS 11.0, *)
    func writeCapturePhoto(_ capturePhoto : AVCapturePhoto) -> URL? {

        
        guard let imageData = capturePhoto.fileDataRepresentation() else {
            print("Error while generating image from photo capture data.");
            return nil
        }
        
        guard let uiImage = UIImage(data: imageData) else {
            print("Unable to generate UIImage from image data.");
            return nil

        }
        
        // generate a corresponding CGImage
        guard let cgImage = uiImage.cgImage else {
            print("cgImage could not be created")
            return nil
        }
        
        
        let croppedImage = cgImage.cropping(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))!
        let uiImage2 = UIImage(cgImage: croppedImage)

        let uuid = UUID().uuidString

        let outFileUrl = URL.init(fileURLWithPath: "\(basePath)/\(uuid).png")
        print(outFileUrl)

        if let data = UIImagePNGRepresentation(uiImage) {
            try? data.write(to: outFileUrl)
        }
        return outFileUrl
//        let photoMetadata = capturePhoto.metadata
//        // Returns corresponting NSCFNumber. It seems to specify the origin of the image
//        //                print("Metadata orientation: ",photoMetadata["Orientation"])
//
//        // Returns corresponting NSCFNumber. It seems to specify the origin of the image
//        print("Metadata orientation with key: ",photoMetadata[String(kCGImagePropertyOrientation)] as Any)

//        guard let deviceOrientationOnCapture = self.deviceOrientationOnCapture else {
//            print("Error retrieving orientation on capture");self.lastPhoto=nil;
//            return
//
//        }

        //        self.lastPhoto = UIImage(cgImage: cgImage, scale: 1.0, orientation: deviceOrientationOnCapture.getUIImageOrientationFromDevice())
//
//
//        print(self.lastPhoto)
//        print("UIImage generated. Orientation:(self.lastPhoto.imageOrientation.rawValue)")
        
//        print(capturePhoto.metadata)
//
//        let unmanagedCGImage = capturePhoto.cgImageRepresentation()!
//        let cgImage = unmanagedCGImage.takeUnretainedValue()
//
//        let croppedImage = cgImage.cropping(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))!
//        let uiImage = UIImage(cgImage: croppedImage)
//
//        let uuid = UUID().uuidString
//
//        let outFileUrl = URL.init(fileURLWithPath: "\(uuid).png")

//        if let data = UIImagePNGRepresentation(uiImage) {
//            try? data.write(to: outFileUrl)
//        }
        print("success!")
//        unmanagedCGImage.release()

//        let ciImage = CIImage(cgImage: cgImage)
//        let croppedImage = ciImage.cropped(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))
//
//        let offsetCroppedImage = croppedImage.transformed(by: CGAffineTransform.init(translationX: 0.0, y: -840.0))
//        let scaledCroppedImage = offsetCroppedImage.transformed(by: CGAffineTransform.init(scaleX: 1200.0/1080.0, y: 1200.0/1080.0))
//
//        var pixelBuffer : CVPixelBuffer? = nil
//        if pixelBuffer == nil {
//            CVPixelBufferCreate(kCFAllocatorDefault, 1200, 1200, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
//        }
//
//        let context:CIContext = CIContext.init(options: nil)
//        context.render(scaledCroppedImage, to: pixelBuffer!)
//        context.
//        try! context.writePNGRepresentation(of: scaledCroppedImage, to: outFileUrl, format: CIFormat(kCVPixelFormatType_32BGRA), colorSpace: cgImage.colorSpace!, options: [:])
//        try! context.writePNGRepresentation(of: scaledCroppedImage, to: outFileUrl, format: CIFormat(kCVPixelFormatType_32BGRA), colorSpace: kCGColorSpaceModelRGB, options: [:])
//        unretainedCgImage?.release()
        
    }
    
    
    
}


