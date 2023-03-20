//
//  ProductDetailViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var product: Product!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.image = UIImage(named: product.images[0])
        productTitle.text = product.name
        productDescription.text = product.description
        productCategory.text = product.category
    }
    
    @IBAction func addToIntentory(_ sender: Any) {
        InventoryService().add(product: product)
    }
    
    
    @IBAction func detectProduct(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get a reference to the view controller you want to push to
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "VisionObjectRecognitionViewController") as! VisionObjectRecognitionViewController
        destinationViewController.product = product
        // Push to the view controller
        navigationController?.pushViewController(destinationViewController, animated: true)
        
        
    }
    

}
