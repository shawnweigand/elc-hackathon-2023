//
//  InventoryCollectionViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/18/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class InventoryCollectionViewController: UICollectionViewController {

    var products: [Product] = InventoryService().list()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(products.count)

        setupNavBar()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    func setupNavBar() {

       let logoImage = UIImage.init(named: "logo")
       let logoImageView = UIImageView.init(image: logoImage)
       logoImageView.frame = CGRect(x:0.0,y:0.0, width:100,height:30)
       logoImageView.contentMode = .scaleAspectFit
       let imageItem = UIBarButtonItem.init(customView: logoImageView)
       let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 100)
       let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
   }
    
    override func viewWillAppear(_ animated: Bool) {
        self.products = InventoryService().list()
        self.collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        
        cell.productImage.image = UIImage(named: product.images[2])
        cell.productTitle.text = product.name
        cell.productSubTitle.text = product.description
        
        return cell
    }

}
