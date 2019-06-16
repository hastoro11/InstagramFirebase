//
//  PreviewController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 16..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import Photos

class PreviewController: UIViewController {
    
    var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.backgroundColor = .orange
        return iv
    }()
    
    var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "cancel_shadow"), for: .normal)
        return btn
    }()
   
    var displayLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(white: 0, alpha: 0.3)
        lbl.text = "Image saved successfully"
        lbl.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        
        return lbl
    }()
    
    var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        guard let image = self.photoImageView.image else {return}
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                print("Error saving image:", error.localizedDescription)
                return
            }
            if success {
                DispatchQueue.main.async {
                    self.displayLabel.center = self.view.center
                    self.view.addSubview(self.displayLabel)
                    self.displayLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        self.displayLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            self.displayLabel.transform = CGAffineTransform.identity
                            self.displayLabel.alpha = 0.0
                        }, completion: { (_) in
                            self.displayLabel.removeFromSuperview()
                            self.dismiss(animated: true, completion: nil)
                        })
                    })
                }
            }
            
        }
    }
}
