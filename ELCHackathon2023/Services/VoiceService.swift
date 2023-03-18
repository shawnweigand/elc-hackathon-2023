//
//  VoiceService.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import Foundation
import AVFoundation

class VoiceService {
    
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        
        synthesizer.speak(utterance)
    }
}
