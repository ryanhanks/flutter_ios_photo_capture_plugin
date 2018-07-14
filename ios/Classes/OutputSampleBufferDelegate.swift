//
//  OutputSampleBufferDelegate.swift
//  photo_capture_plugin
//
//  Created by Ryan Hanks on 7/10/18.
//

import Foundation
import AVFoundation

@available(iOS 9.0, *)
public class OutputSampleBufferDelegate : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let outputSampleFlutterTexture : OutputSampleFlutterTexture
    
    init(outputSampleFlutterTexture : OutputSampleFlutterTexture) {
        self.outputSampleFlutterTexture = outputSampleFlutterTexture
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        self.outputSampleFlutterTexture.setOutputSampleBuffer(outputSampleBuffer: sampleBuffer)
    }
}
