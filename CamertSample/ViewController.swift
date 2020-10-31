//
//  ViewController.swift
//  CamertSample
//
//  Created by maochun on 2020/10/15.
//

import UIKit


class ViewController: UIViewController {

    lazy var takePicButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Take a picture", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(takePicAction), for: .touchUpInside)
        
         
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
         
        ])

        return btn
    }()
    
    lazy var recordVideoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Record video", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(recordVideoAction), for: .touchUpInside)
        
         
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
         
        ])

        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        let _ = self.recordVideoButton
        let _ = self.takePicButton
    }


    @objc func takePicAction(){
        let takePicViewCtrl = TakePictureViewController()
        takePicViewCtrl.modalPresentationStyle = .overFullScreen
        self.present(takePicViewCtrl, animated: true, completion: nil)
    }
    
    @objc func recordVideoAction(){
        let takePicViewCtrl = RecordVideoViewController()
        takePicViewCtrl.modalPresentationStyle = .overFullScreen
        self.present(takePicViewCtrl, animated: true, completion: nil)
    }
}

