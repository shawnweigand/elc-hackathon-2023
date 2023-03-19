//
//  RecommendationViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/19/23.
//

import UIKit

class RecommendationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func drySkinAction(_ sender: Any) {
        
        goToDetails(type: "Dry Skin")
        
        
    }
    
    @IBAction func sensitiveSkinAction(_ sender: Any) {
        goToDetails(type: "Sensitive Skin")
    }
    
    @IBAction func OilySkinAction(_ sender: Any) {
        goToDetails(type: "Oily Skin")
    }
    
    func goToDetails(type: String){
        // Create a new view controller to present
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Get a reference to the view controller you want to push to
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "RecommendationResultsViewController") as! RecommendationResultsViewController
        
        destinationViewController.skinType = type
        destinationViewController.modalPresentationStyle = .pageSheet
        
        present(destinationViewController, animated: true, completion: nil)
    }
    

}
