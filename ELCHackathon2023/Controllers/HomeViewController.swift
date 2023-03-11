//
//  ViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/10/23.
//

import UIKit

class HomeViewController: UIViewController {

    
    let categories = ["Lipstick", "Foundation", "Cleanser", "Toner"]
 
    @IBOutlet weak var categoriesCollectionview: UICollectionView!
    
    var categoriesCollectionViewLayout: CustomCollectionViewLayout = CustomCollectionViewLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        categoriesCollectionview.backgroundColor = .clear
        categoriesCollectionview.decelerationRate = .fast
        categoriesCollectionview.contentInsetAdjustmentBehavior = .never
        categoriesCollectionview.showsHorizontalScrollIndicator = false
        categoriesCollectionview.showsVerticalScrollIndicator = false
        categoriesCollectionview.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10)
        
        categoriesCollectionview.delegate = self
        categoriesCollectionview.dataSource = self
        
        
        categoriesCollectionview.collectionViewLayout = categoriesCollectionViewLayout
        categoriesCollectionViewLayout.scrollDirection = .horizontal
        categoriesCollectionViewLayout.minimumLineSpacing = 10.0
        categoriesCollectionViewLayout.minimumInteritemSpacing = 10.0
        categoriesCollectionViewLayout.itemSize.width = 126
        categoriesCollectionViewLayout.itemSize.height = 50
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 0, section: 0)
        categoriesCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        categoriesCollectionViewLayout.currentPage = indexPath.item
        categoriesCollectionViewLayout.previousOffet = categoriesCollectionViewLayout.updateOffset(categoriesCollectionview)
        if let cell = categoriesCollectionview.cellForItem(at: indexPath) as? CategoryCell{
            transformCell(cell)
        }
    }


}


//MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.categoriesCollectionview.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = self.categories[indexPath.item]
        cell.activeIndicatorView.isHidden = true
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 126, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == categoriesCollectionViewLayout.currentPage {
            print("selected")
        } else {
            categoriesCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            categoriesCollectionViewLayout.currentPage = indexPath.item
            categoriesCollectionViewLayout.previousOffet = categoriesCollectionViewLayout.updateOffset(categoriesCollectionview)
            setupCell()
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
        if let cell = categoriesCollectionview.cellForItem(at: indexPath)  as? CategoryCell{
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
            
        }
        
        for otherCell in categoriesCollectionview.visibleCells as! [CategoryCell] {
            
            if let indexPath = categoriesCollectionview.indexPath(for: otherCell){
                if indexPath.item != categoriesCollectionViewLayout.currentPage {
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                        otherCell.activeIndicatorView.isHidden = true
                    }
                }
            }

        }

        
    }
    
}
