//
//  RecommendationResultsViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/19/23.
//

import UIKit
import Lottie
class RecommendationResultsViewController: UIViewController {

    let openAIService: OpenAIService = OpenAIService()
    @IBOutlet weak var textView: UITextView!
    private var animationView: LottieAnimationView?
    
    var skinType: String = ""
    
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSkincareRoutine()
        setupAnimation()
    }
    
    
    func setupAnimation(){
        animationView = .init(name: "makeup")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        overlayView.addSubview(animationView!)
        animationView!.play()
    }
    
    
    func setupSkincareRoutine()
    {
        let prompt = openAIService.generatePromptForRecommandations(type: self.skinType)
       
        self.openAIService.client.sendCompletion(with: prompt, model: .gpt3(.davinci),maxTokens: 300) { result in
            switch result {
            case .success(let success):
                print(success.choices)
                DispatchQueue.main.async {
                    self.textView.text = success.choices.first?.text
                    self.overlayView.isHidden = true
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }


}
