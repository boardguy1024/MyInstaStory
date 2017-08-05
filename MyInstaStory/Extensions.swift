//
//  Extensions.swift
//  MyInsta
//
//  Created by park kyung suk on 2017/08/04.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

extension UITextField {
    
    // カスタムTextFieldに変更するメソッド
    func setCustomBlackStyleTextField() {
        backgroundColor = .clear
        textColor = .white
        tintColor = .white
        guard let placeHolder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes:
            [NSForegroundColorAttributeName: UIColor(white:1.0 , alpha: 0.6)])
        
        let bottomSeparatorLineLayer = CALayer()
        bottomSeparatorLineLayer.frame = CGRect(x: 0, y: 35, width: 1000, height: 0.6)
        bottomSeparatorLineLayer.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomSeparatorLineLayer)
    }

}
