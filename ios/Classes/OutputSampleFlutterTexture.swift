//
//  OutputSampleFlutterTexture.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/9/18.
//

import Flutter
import Foundation
import AVFoundation
import VideoToolbox
@available(iOS 9.0, *)
// rename to CaptureSessionPreviewFlutterTexture
class OutputSampleFlutterTexture : NSObject, FlutterTexture {
    let flutterTextureRegistry : FlutterTextureRegistry
    private var pixelBuffer : CVPixelBuffer? = nil
    
    init(flutterTextureRegistry : FlutterTextureRegistry) {
        self.flutterTextureRegistry = flutterTextureRegistry
        
    }
    
    var textureId : Int64? = nil
    func setTextureId(textureId: Int64){
        self.textureId = textureId
    }
    
    var outputSampleBuffer : CMSampleBuffer? = nil
    func setOutputSampleBuffer(outputSampleBuffer: CMSampleBuffer) {
        self.outputSampleBuffer = outputSampleBuffer
        flutterTextureRegistry.textureFrameAvailable(self.textureId!)
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        if outputSampleBuffer == nil { return nil }
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(outputSampleBuffer!)!
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let croppedImage = ciImage.cropped(to: CGRect(x: 0, y: 840, width: 1080, height: 1080))
        
        let offsetCroppedImage = croppedImage.transformed(by: CGAffineTransform.init(translationX: 0.0, y: -840.0))
        let scaledCroppedImage = offsetCroppedImage.transformed(by: CGAffineTransform.init(scaleX: 1200.0/1080.0, y: 1200.0/1080.0))
        if pixelBuffer == nil {
            CVPixelBufferCreate(kCFAllocatorDefault, 1200, 1200, kCVPixelFormatType_32BGRA, nil, &(self.pixelBuffer))
        }
        
        
        let context:CIContext = CIContext.init(options: nil)
        context.render(scaledCroppedImage, to: pixelBuffer!)
        //        let outFileUrl = URL.init(fileURLWithPath: "test.png")
        //        context.writePNGRepresentation(of:  to: <#T##URL#>, format: <#T##CIFormat#>, colorSpace: <#T##CGColorSpace#>, options: <#T##[AnyHashable : Any]#>)
        return Unmanaged.passRetained(pixelBuffer!)
        //        return Unmanaged.passRetained(imageBuffer)
    }
    
    
}
