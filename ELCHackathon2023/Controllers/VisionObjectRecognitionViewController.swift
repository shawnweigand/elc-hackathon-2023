//
//  VisionObjectRecognitionViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/16/23.
//

import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: ScanViewController {
    
    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
    private var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "OriginsProductDetection", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.handleResults(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func handleResults(_ results: [Any]) {
        //        let classif = results.compactMap({$0 as? VNRecognizedObjectObservation})
        //            .filter({$0.labels[0].confidence > 0.5})
        //            .map({$0.labels[0].identifier})
        //
        //        print(classif)
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
//            print(topLabelObservation.identifier, topLabelObservation.confidence)
            
            return productFound(slug: topLabelObservation.identifier)
            
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//
//            //            VoiceService().speak(text: "Product found")
//
//            let utterance = AVSpeechUtterance(string: "Found")
//            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//            utterance.rate = 0.5
//            synthesizer.speak(utterance)
            
        }
    }
    
    
    func productFound(slug: String){
        
        stopCaptureSession()
        // Vibrate the phone
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Text to speech
        let utterance = AVSpeechUtterance(string: "Product has been found.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        
//        Find the product with that id
        let product = ProductsService().list().first(where:({$0.slug == slug}))
        
        //Display the product details
        // Get a reference to the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Get a reference to the view controller you want to push to
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        destinationViewController.product = product
        // Push to the view controller
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    
    
    
    
    
    func downsamplePixelBuffer(_ pixelBuffer: CVPixelBuffer, to size: CGSize) -> CVPixelBuffer? {
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let scale = CGAffineTransform(scaleX: size.width / CGFloat(CVPixelBufferGetWidth(pixelBuffer)), y: size.height / CGFloat(CVPixelBufferGetHeight(pixelBuffer)))
        ciImage = ciImage.transformed(by: scale)
        
        let ciContext = CIContext(options: nil)
        var downsampledPixelBuffer: CVPixelBuffer?
        let result = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, [kCVPixelBufferCGImageCompatibilityKey: true, kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary, &downsampledPixelBuffer)
        
        if result == kCVReturnSuccess {
            ciContext.render(ciImage, to: downsampledPixelBuffer!)
            return downsampledPixelBuffer
        }
        return nil
    }

    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
        let newSize = CGSize(width: 640, height: 480) // VGA640 resolution
           guard let downsampledPixelBuffer = downsamplePixelBuffer(pixelBuffer, to: newSize) else {
               return
           }

           let exifOrientation = exifOrientationFromDeviceOrientation()
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: downsampledPixelBuffer, orientation: exifOrientation, options: [:])
           do {
               try imageRequestHandler.perform(self.requests)
           } catch {
               print(error)
           }
  
//
//        let exifOrientation = exifOrientationFromDeviceOrientation()
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
//        do {
//            try imageRequestHandler.perform(self.requests)
//        } catch {
//            print(error)
//        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        setupVision()
        startCaptureSession()
    }
}

