//
//  RecordVideoViewController.swift
//  CamertSample
//
//  Created by maochun on 2020/10/16.
//

import UIKit
import AVFoundation

class RecordVideoViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoInput : AVCaptureDeviceInput?
    var audioInput : AVCaptureDeviceInput?
    var movieOutput = AVCaptureMovieFileOutput()
    
    
    lazy var recordButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "record_btn_on"), for: .normal)
  
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            btn.widthAnchor.constraint(equalToConstant: 80),
            btn.heightAnchor.constraint(equalToConstant: 80)
        ])

        return btn
    }()
    
    lazy var switchCamButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "switchcam_btn_normal"), for: .normal)
        btn.setImage(UIImage(named: "switchcam_btn_press"), for: .highlighted)
        btn.setTitleColor(.blue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(switchCameraAction), for: .touchUpInside)
        

        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.centerYAnchor.constraint(equalTo: self.recordButton.centerYAnchor),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            btn.widthAnchor.constraint(equalToConstant: 70),
            btn.heightAnchor.constraint(equalToConstant: 70)
        ])

        return btn
    }()
    
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close_btn_normal"), for: .normal)
        btn.setImage(UIImage(named: "close_btn_press"), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        

         
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            btn.widthAnchor.constraint(equalToConstant: 80),
            btn.heightAnchor.constraint(equalToConstant: 80)
        ])

        return btn
    }()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        

        if !recordAVInit(){
            let _ = self.closeButton
        }
    }
    
    private func recordAVInit() -> Bool{
        guard let backCam = AVCaptureDevice.default(for: AVMediaType.video) else{
            return false
        }
        
        guard let audioDev = AVCaptureDevice.default(for: AVMediaType.audio) else{
            return false
        }
        
        do{
            videoInput = try AVCaptureDeviceInput(device: backCam)
            audioInput = try AVCaptureDeviceInput(device: audioDev)
        }catch{
            print("AVCaptureDeviceInput exception \(error.localizedDescription)")
            return false
        }
        
        guard let vInput = videoInput, let aInput = audioInput else{
            return false
        }
        
        guard captureSession.canAddInput(vInput) else {
            return false
        }
        
        guard captureSession.canAddInput(aInput) else {
            return false
        }
        
        guard captureSession.canAddOutput(self.movieOutput) else{
            return false
        }
        
        captureSession.addInput(vInput)
        captureSession.addInput(aInput)
        captureSession.addOutput(self.movieOutput)
        
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = self.view.frame
        cameraLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(cameraLayer)
        
        let _ = self.recordButton
        let _ = self.switchCamButton
        let _ = self.closeButton
        
        captureSession.startRunning()
        
        return true
    }
    
    
    @objc func recordAction(){
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            self.recordButton.setImage(UIImage(named: "record_btn_on"), for: .normal)
        } else {
            self.recordButton.setImage(UIImage(named: "record_btn_off"), for: .normal)
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("tmp_output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            
            movieOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
        }
    }
    
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }

        return nil
    }
    
    @objc func switchCameraAction(){
        
        DispatchQueue.global().async {
            guard let currentCameraInput: AVCaptureInput = self.captureSession.inputs.first else {
                return
            }

            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if input.device.position == .back {
                    newCamera = self.cameraWithPosition(position: .front)
                } else {
                    newCamera = self.cameraWithPosition(position: .back)
                }
            }
        
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err as NSError {
                print("create new camera input failed! \(err.localizedDescription)")
                return
            }

            
            self.captureSession.beginConfiguration()
            self.captureSession.removeInput(currentCameraInput)
            self.captureSession.addInput(newVideoInput)
            self.captureSession.commitConfiguration()
            
  
        }
    
    }
    
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
}


extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
    
    
}
