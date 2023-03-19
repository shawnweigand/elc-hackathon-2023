//
//  ViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/10/23.
//

import UIKit
import SwiftyJSON
class HomeViewController: UIViewController {
    
    
    let categories = ["All", "Eye Care", "Treatment", "Skin Care"]
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var categoriesCollectionViewLayout: CustomCollectionViewLayout = CustomCollectionViewLayout()
    
    var productService: ProductsService = ProductsService()
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavBar()
        setupCategories()
        setupProducts()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 0, section: 0)
        categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        categoriesCollectionViewLayout.currentPage = indexPath.item
        categoriesCollectionViewLayout.previousOffet = categoriesCollectionViewLayout.updateOffset(categoriesCollectionView)
        if let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell{
            transformCell(cell)
        }
    }
    
    func setupCategories(){
        // Setup categories collection view
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.decelerationRate = .fast
        categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10)
        categoriesCollectionView.collectionViewLayout = categoriesCollectionViewLayout
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        categoriesCollectionViewLayout.scrollDirection = .horizontal
        categoriesCollectionViewLayout.minimumLineSpacing = 1.0
        categoriesCollectionViewLayout.minimumInteritemSpacing = 1.0
        categoriesCollectionViewLayout.itemSize.width = 126
        categoriesCollectionViewLayout.itemSize.height = 50
    }
    
    func setupProducts(){
        // Setup products collection view
        productsCollectionView.backgroundColor = .clear
        productsCollectionView.decelerationRate = .fast
        productsCollectionView.contentInsetAdjustmentBehavior = .never
        productsCollectionView.showsHorizontalScrollIndicator = false
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10)
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        let productCollectionViewLayout = UICollectionViewFlowLayout()
        
        productCollectionViewLayout.scrollDirection = .vertical
        productCollectionViewLayout.minimumLineSpacing = 19.0
        productCollectionViewLayout.minimumInteritemSpacing = 1.0
        productsCollectionView.collectionViewLayout = productCollectionViewLayout
        
        products = productService.list()
        productsCollectionView.reloadData()
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
    

    func filterProducts(){
        if categoriesCollectionViewLayout.currentPage == 0{
            products = productService.list()
            productsCollectionView.reloadData()
            return
        }
        products = productService.list().filter({$0.category == self.categories[categoriesCollectionViewLayout.currentPage]})
        productsCollectionView.reloadData()
        print("reload")
        
    }
  

    
    
}


//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return self.categories.count
        }
        //Product collectionview
        
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = self.categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            cell.categoryLabel.text = self.categories[indexPath.item]
            cell.activeIndicatorView.isHidden = true
            return cell
        }
        
        let cell = self.productsCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        
        cell.productImage.image = UIImage(named: product.images[2])
        cell.productTitle.text = product.name
        cell.productSubTitle.text = product.description
        
        return cell
       
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == categoriesCollectionView {
            return CGSize(width: 126, height: 50)
        }
        
        return CGSize(width: 300, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            if indexPath.item == categoriesCollectionViewLayout.currentPage {
                print("selected")
                filterProducts()
            } else {
                //for swipe to work
                categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                categoriesCollectionViewLayout.currentPage = indexPath.item
                categoriesCollectionViewLayout.previousOffet = categoriesCollectionViewLayout.updateOffset(categoriesCollectionView)
                setupCell()
            }
            return 
        }
        
            //        clicked on a product
            //        Find the product with that id
                let product = products[indexPath.row]
                
                //Display the product details
                // Get a reference to the storyboard
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                // Get a reference to the view controller you want to push to
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                destinationViewController.product = product
                // Push to the view controller
                navigationController?.pushViewController(destinationViewController, animated: true)
     
    }
    
    
}

extension HomeViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            setupCell()
        }
    }
    
    private func setupCell(){
        let indexPath = IndexPath(item: categoriesCollectionViewLayout.currentPage, section: 0)
        if let cell = categoriesCollectionView.cellForItem(at: indexPath)  as? CategoryCell{
            transformCell(cell)
        }
        
    }
    private func transformCell(_ cell: CategoryCell, isEffect: Bool = true){
        
        if !isEffect {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            cell.activeIndicatorView.isHidden = false
            cell.activeIndicatorView.layer.cornerRadius = 8
            cell.activeIndicatorView.layer.masksToBounds = true
            cell.activeIndicatorView.layer.opacity = 0.8
            cell.categoryLabel.textColor = .black
            
        }
        filterProducts()
        
        for otherCell in categoriesCollectionView.visibleCells as! [CategoryCell] {
            
            if let indexPath = categoriesCollectionView.indexPath(for: otherCell){
                if indexPath.item != categoriesCollectionViewLayout.currentPage {
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                        otherCell.activeIndicatorView.isHidden = true
                        otherCell.categoryLabel.textColor = .lightGray
                    }
                }
            }
            
        }
        
        
    }
    
}
