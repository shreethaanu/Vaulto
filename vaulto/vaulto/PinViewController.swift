//
//  PinViewController.swift
//  vaulto
//
//  Created by PRoVMac on 19/11/18.
//  Copyright © 2018 strlab. All rights reserved.
//

import UIKit
import AVKit

class PinViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var pinText: UITextField!
    var device: AVCaptureDevice?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var cameraImage: UIImage?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setupCamera()
    }
    
    func setupCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: AVMediaType.video,
                                                                position: .front)
        device = discoverySession.devices[0]
        
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch {
            return
        }
        
        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        
        let queue = DispatchQueue(label: "cameraQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.addOutput(output)
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        previewLayer?.isHidden = true
        view.layer.insertSublayer(previewLayer!, at: 0)
        
        captureSession?.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = UnsafeMutableRawPointer(CVPixelBufferGetBaseAddress(imageBuffer!))
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
        let width = CVPixelBufferGetWidth(imageBuffer!)
        let height = CVPixelBufferGetHeight(imageBuffer!)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo:
            CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        let newImage = newContext!.makeImage()
        cameraImage = UIImage(cgImage: newImage!)
        
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    }
    
    func setupTimer() {
        if pinText.text == "1249" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "MenusViewController") as! MenusViewController
            
            self.present(resultViewController, animated:true, completion:nil)
        }
        else {
           // let alert = UIAlertController.init(title: "Venam, Philpsuu", message: "moodtu poda sunni !!", preferredStyle: .alert)
            snapshot()
            //self.present(alert, animated: true, completion: nil)
        }
    }
    func playSound() {
        let path = Bundle.main.path(forResource: "philipu", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch {
            
            print ("There is an issue with this code!")
            
        }
        }
    @objc func snapshot() {
        print("SNAPSHOT")
        playSound() 
        let alert = UIAlertController.init(title: "Venam, Philpsuu", message: "moodtu poda junnni !!", preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x:220, y:10, width:40, height:40))
        imageView.image = self.cameraImage
        alert.view.addSubview(imageView)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goAction(_ sender: Any) {
        setupTimer()
}
}
