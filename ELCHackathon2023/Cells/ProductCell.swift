//
//  ProductCell.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/12/23.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productSubTitle: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Set corner radius for the contentView
            contentView.layer.cornerRadius = 18
            contentView.layer.masksToBounds = true
            
            // Set corner radius for the cell
            layer.cornerRadius = 18
            layer.masksToBounds = false
            
            // Add shadow to the cell
            layer.shadowColor = UIColor(hex: "#98FF98").cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = 4
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
}
