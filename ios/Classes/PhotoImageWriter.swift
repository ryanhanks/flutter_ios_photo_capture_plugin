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

public extension UIImage {
    
    /// Extension to fix orientation of an UIImage without EXIF
    func fixOrientation() -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        if imageOrientation == .up { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .up, .down, .left, .right:
            break
        }
        
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        
        // something failed -- return original
        return self
    }
}

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

        let unmanagedCGImage = capturePhoto.cgImageRepresentation()!
        let cgImage1 = unmanagedCGImage.takeUnretainedValue()
        let uiImage1 : UIImage = UIImage(cgImage: cgImage1)
        print(capturePhoto.metadata);
        print(capturePhoto.metadata[kCGImagePropertyOrientation as String]!);
//        print(capturePhoto.)
        guard let imageData = capturePhoto.fileDataRepresentation() else {
            print("Error while generating image from photo capture data.");
            return nil
        }
//        UIImage(
        guard let uiImage = UIImage(data: imageData) else {
            print("Unable to generate UIImage from image data.");
            return nil

        }
        
        // generate a corresponding CGImage
        guard let cgImage = uiImage.cgImage else {
            print("cgImage could not be created")
            return nil
        }
        
        
//        let croppedImage = cgImage.cropping(to: CGRect(x: 0, y: 0, width: 1080, height: 1080))!
        let croppedImage = cgImage1.cropping(to: CGRect(x: 0, y: 0, width: 1080, height: 1080))!

        let uiImage2 = UIImage(cgImage: croppedImage, scale: 1.0, orientation: UIImageOrientation.right)
        let uiImage3 = uiImage2.fixOrientation()

        let uuid = UUID().uuidString

        let outFileUrl = URL.init(fileURLWithPath: "\(basePath)/\(uuid).png")
        print(outFileUrl)

        if let data = UIImagePNGRepresentation(uiImage3) {
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


