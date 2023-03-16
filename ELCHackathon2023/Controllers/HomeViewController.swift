//
//  ViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/10/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    let categories = ["Lipstick", "Foundation", "Cleanser", "Toner"]
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var categoriesCollectionViewLayout: CustomCollectionViewLayout = CustomCollectionViewLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        categoriesCollectionViewLayout.minimumLineSpacing = 10.0
        categoriesCollectionViewLayout.minimumInteritemSpacing = 10.0
        categoriesCollectionViewLayout.itemSize.width = 126
        categoriesCollectionViewLayout.itemSize.height = 50
        
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
        productCollectionViewLayout.minimumLineSpacing = 5.0
        productCollectionViewLayout.minimumInteritemSpacing = 5.0
        productsCollectionView.collectionViewLayout = productCollectionViewLayout
        
        
        
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
    
    
}


//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return self.categories.count
        }
        //Product collectionview
        
       return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = self.categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
            cell.categoryLabel.text = self.categories[indexPath.item]
            cell.activeIndicatorView.isHidden = true
            return cell
        }
        
        let cell = self.productsCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath)
        return cell
       
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == categoriesCollectionView {
            return CGSize(width: 126, height: 50)
        }
        
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            if indexPath.item == categoriesCollectionViewLayout.currentPage {
                print("selected")
            } else {
                categoriesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                categoriesCollectionViewLayout.currentPage = indexPath.item
                categoriesCollectionViewLayout.previousOffet = categoriesCollectionViewLayout.updateOffset(categoriesCollectionView)
                setupCell()
            }
        }
        
        
       
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
