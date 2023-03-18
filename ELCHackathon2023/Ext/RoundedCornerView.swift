//
//  RoundedCornerView.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import UIKit

class RoudnedCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    {
        didSet
        {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0
    {
        didSet
        {
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        }
    }
    
    
}
