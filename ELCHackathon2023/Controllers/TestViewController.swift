//
//  TestViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/15/23.
//

import UIKit
import CoreNFC
import AVKit
import AVFoundation
import Vision


class TestViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    @IBOutlet weak private var previewView: UIView!
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // to be implemented in the subclass
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        rootLayer = previewView.layer
//        previewLayer.frame = rootLayer.bounds
//        rootLayer.addSublayer(previewLayer)
    }
    
    func startCaptureSession() {
        session.startRunning()
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("frame dropped")
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}

//class TestViewController: UIViewController {
//    //NFC
//    var session: NFCTagReaderSession?
//    //Camera
//    let captureSession = AVCaptureSession()
//    var captureDevice : AVCaptureDevice! = nil
//    var devicePosition : AVCaptureDevice.Position = .front
//
//    //Visions
//    var requests = [VNRequest]()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupVision()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        prepareCamera()
//
//    }
//
//    func setupVision(){
//        guard let visionModel = try? VNCoreMLModel(for: OriginsProductDetection().model) else {
//            print("couldn't load model")
//            fatalError("couldn't load model")
//        }
//
//        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
//        classificationRequest.imageCropAndScaleOption = .centerCrop
//        self.requests = [classificationRequest]
//
//    }
//
//    func handleClassification(request: VNRequest, error: Error?){
//        guard let observations = request.results else { print("no results"); return}
//
//        let classification = observations.com
//    }
//
//    @IBAction func test(_ sender: Any) {
//        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
//        self.session?.alertMessage = "Hold your phone"
//        self.session?.begin()
//    }
//
//
//}
//
//extension TestViewController: NFCTagReaderSessionDelegate{
//    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
//        print("error")
//    }
//
//    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
//        print("found it")
//    }
//
//    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
//        print("Session started")
//    }
//}
//
//
//extension TestViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
//
//    func prepareCamera(){
//        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
//        captureDevice = availableDevices.first
//
//        beingSesion()
//    }
//
//    func beingSesion(){
//        do {
//            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(captureDeviceInput)
//        } catch{
//            print("Could not get video")
//            return
//        }
//
//        captureSession.beginConfiguration()
//        captureSession.sessionPreset = .vga640x480
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
//        dataOutput.alwaysDiscardsLateVideoFrames = true
//
//        if captureSession.canAddInput(dataOutput){
//            captureSession.addOutput(dataOutput)
//        }
//
//        captureSession.commitConfiguration()
//
//        let queue = DispatchQueue(label: "captureQueue")
//        dataOutput.setSampleBufferDelegate(self, queue: queue)
//
//        captureSession.startRunning()
//
//    }
//
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
//
//        let exifOrientation
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation)
//
//
//        do {
//            try imageRequestHandler.perform(self.requests)
//        } catch{
//            print(error)
//        }
//
//
//    }
//
//
//
//}
