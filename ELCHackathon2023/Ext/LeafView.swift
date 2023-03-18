//
//  LeafView.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import Foundation
import UIKit

class LeafView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
           let cornerRadius: CGFloat = 70.0
           
           // Create a new path with rounded corners in the bottom right and top left corners
           let path = UIBezierPath(roundedRect: bounds,
                                   byRoundingCorners: [.bottomRight, .topLeft],
                                   cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
           
           // Create a shape layer with the path
           let maskLayer = CAShapeLayer()
           maskLayer.path = path.cgPath
           
           // Set the fill color to opaque white
           maskLayer.fillColor = UIColor.white.cgColor
           
           // Set the stroke color to clear
           maskLayer.strokeColor = UIColor.clear.cgColor
           
           // Apply the mask layer to the view's layer
           layer.mask = maskLayer
           
           // Set the background color
//           backgroundColor = UIColor(hex: "")
       }
}

