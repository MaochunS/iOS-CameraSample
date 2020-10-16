//
//  PhotoPreviewViewController.swift
//  CamertSample
//
//  Created by maochun on 2020/10/16.
//

import UIKit

class PhotoPreviewViewController: UIViewController {
    
    lazy var okButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
         
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            btn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 2/3),
            btn.heightAnchor.constraint(equalToConstant: 45)
        ])

        return btn
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
         
        self.view.addSubview(btn)

        NSLayoutConstraint.activate([
         
            btn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            btn.rightAnchor.constraint(equalTo: self.okButton.leftAnchor, constant: -10),
            btn.heightAnchor.constraint(equalToConstant: 45)
         
        ])

        return btn
    }()
    
    lazy var picView : UIImageView = {
        let theView = UIImageView()
        theView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(theView)
        
        NSLayoutConstraint.activate([
            
            theView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
            theView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            theView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            theView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
        ])
        
        return theView
    }()
    
    var previewPicture : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        let _ = self.cancelButton
        self.picView.image = previewPicture
    }
    
    @objc func okAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
}
