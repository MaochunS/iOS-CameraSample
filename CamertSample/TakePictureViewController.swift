//
//  TakePictureViewController.swift
//  CamertSample
//
//  Created by maochun on 2020/10/16.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var deviceInput : AVCaptureDeviceInput?
    var photoOutput : AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    
    lazy var takePicButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "takepic_btn_normal"), for: .normal)
        btn.setImage(UIImage(named: "takepic_btn_press"), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
        
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
         
            btn.centerYAnchor.constraint(equalTo: self.takePicButton.centerYAnchor),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            btn.widthAnchor.constraint(equalToConstant: 70),
            btn.heightAnchor.constraint(equalToConstant: 70)
        ])

        return btn
    }()
    
    lazy var lightingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "lighting_btn_normal"), for: .normal)
        btn.setImage(UIImage(named: "lighting_btn_press"), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(toggleLightingAction), for: .touchUpInside)
        
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.centerYAnchor.constraint(equalTo: self.closeButton.centerYAnchor),
            btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
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
    
   
    
    var camTorchOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        

        if !capturePicInit(){
            let _ = self.closeButton
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.captureSession.isRunning{
            self.captureSession.stopRunning()
        }
    }
    
    private func capturePicInit() -> Bool{
        guard let backCam = AVCaptureDevice.default(for: AVMediaType.video) else{
            return false
        }
        
        
        do{
            deviceInput = try AVCaptureDeviceInput(device: backCam)
        }catch{
            print("AVCaptureDeviceInput exception \(error.localizedDescription)")
            return false
        }
        
        guard let devInput = deviceInput else{
            return false
        }
        
        guard captureSession.canAddInput(devInput) else {
            return false
        }
        
        guard captureSession.canAddOutput(photoOutput) else{
            return false
        }
        
        captureSession.addInput(devInput)
        captureSession.addOutput(photoOutput)
        
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = self.view.frame
        cameraLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(cameraLayer)
        
        let _ = self.takePicButton
        let _ = self.lightingButton
        let _ = self.switchCamButton
        let _ = self.closeButton
        
        captureSession.startRunning()
        
        return true
    }
    
    @objc func takePictureAction(){
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
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
        
        UIView.transition(with: self.view, duration: 0.8, options: .transitionFlipFromLeft, animations: nil)
        
        DispatchQueue.global().async { [self] in
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
            defer {self.captureSession.commitConfiguration()}

            
            self.captureSession.removeInput(currentCameraInput)
            self.captureSession.addInput(newVideoInput)
        
            
            self.camTorchOn = false
        }
    
    }
    
    @objc func toggleLightingAction(){
        DispatchQueue.global().async {
            guard let currentCameraInput: AVCaptureInput = self.captureSession.inputs.first else {
                return
            }

            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if input.device.hasTorch{
                    do{
                        try input.device.lockForConfiguration()
                        
                        if self.camTorchOn{
                            input.device.torchMode = .off
                        }else{
                            input.device.torchMode = .on
                        }
                        
                        self.camTorchOn = !self.camTorchOn
                        
                        input.device.unlockForConfiguration()
                        
                    }catch{
                        
                    }
                    
                }
            }
     
        }
    }
    
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension TakePictureViewController : AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let previewViewCtrl = PhotoPreviewViewController()
        previewViewCtrl.modalPresentationStyle = .overFullScreen
        previewViewCtrl.previewPicture = previewImage
        self.present(previewViewCtrl, animated: true, completion: nil)
    }
}
