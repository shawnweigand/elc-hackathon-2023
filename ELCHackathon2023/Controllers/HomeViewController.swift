//
//  ViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/10/23.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var categoriesCollectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionview.delegate = self
        categoriesCollectionview.dataSource = self
        
    }


}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.categoriesCollectionview.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as UICollectionViewCell
        
        
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

}

