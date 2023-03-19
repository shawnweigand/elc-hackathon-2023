//
//  RoutineViewController.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/19/23.
//

import UIKit
import Lottie
class RoutineViewController: UIViewController {

    
    let openAIService: OpenAIService = OpenAIService()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var overlayView: UIView!
    
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimation()
        setupSkincareRoutine()
        
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
        let prompt = openAIService.generatePromptForRoutine()
        print(prompt)

        self.openAIService.client.sendCompletion(with: prompt, model: .gpt3(.davinci),maxTokens: 300) { result in
            switch result {
            case .success(let success):
                print(success.choices.first?.text ?? "")
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


extension CGRect {
    func centeredIn(_ rect: CGRect) -> CGRect {
        let originX = rect.origin.x + (rect.width - self.width) / 2
        let originY = rect.origin.y + (rect.height - self.height) / 2
        return CGRect(origin: CGPoint(x: originX, y: originY), size: self.size)
    }
}
