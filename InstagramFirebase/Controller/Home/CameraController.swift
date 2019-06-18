//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 16..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "cancel_shadow"), for: .normal)
        return btn
    }()
    
    var captureButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: - AVFoundation
    var captureSession: AVCaptureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    var captureOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        transitioningDelegate = self
        configure()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        view.addSubview(captureButton)
        captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer()
        rightSwipeGestureRecognizer.direction = .right
        rightSwipeGestureRecognizer.addTarget(self, action: #selector(rightSwipe))
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let letfSwipeGestureRecognizer = UISwipeGestureRecognizer()
        letfSwipeGestureRecognizer.direction = .left
        letfSwipeGestureRecognizer.addTarget(self, action: #selector(leftSwipe))
        view.addGestureRecognizer(letfSwipeGestureRecognizer)
        
    }
    
    @objc func rightSwipe() {
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { (input) in
            captureSession.removeInput(input)
        }
        if frontCamera != nil {
            currentDevice = frontCamera
        }
        guard let input = try? AVCaptureDeviceInput(device: currentDevice) else {return}
        captureSession.addInput(input)
        captureSession.commitConfiguration()
    }
    
    @objc func leftSwipe() {
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { (input) in
            captureSession.removeInput(input)
        }
        if backCamera != nil {
            currentDevice = backCamera
        }
        guard let input = try? AVCaptureDeviceInput(device: currentDevice) else {return}
        captureSession.addInput(input)
        captureSession.commitConfiguration()
    }
    
    fileprivate func configure() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        discoverySession.devices.forEach { (device) in
            if device.position == .back {
                backCamera = device
            } else if device.position == .front {
                frontCamera = device
            }
        }
        
        currentDevice = backCamera
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {return}
        
        
        captureSession.beginConfiguration()
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }
        captureSession.addOutput(captureOutput)
        captureSession.commitConfiguration()
        
        view.layer.addSublayer(previewLayer)
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.frame
        
        captureSession.startRunning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        settings.isHighResolutionPhotoEnabled = true
        captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        let image = UIImage(data: imageData)
        let previewController = PreviewController()
        previewController.photoImageView.image = image
        present(previewController, animated: true, completion: nil)
    }
}


extension CameraController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CameraControllerTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cameraControllerTransition = CameraControllerTransition()
        cameraControllerTransition.presenting = false
        return cameraControllerTransition
    }
}
