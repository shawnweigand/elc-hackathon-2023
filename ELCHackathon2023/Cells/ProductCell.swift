//
//  ProductCell.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/12/23.
//

import UIKit

class ProductCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set corner radius
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        // Set Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        
        self.backgroundColor = .white
    }
}
