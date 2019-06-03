//
//  LoginButton.swift
//  InstagramFirebase
//
//  Created by Gabor Sornyei on 2019. 06. 03..
//  Copyright © 2019. Gabor Sornyei. All rights reserved.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = kLOGINBUTTON_COLOR
        setTitleColor(.white, for: .normal)
    }
}
