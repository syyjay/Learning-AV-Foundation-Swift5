//
//  THSpeechController.swift
//  HelloAVF_Starter_Swift
//
//  Created by nathan on 2020/12/24.
//

import UIKit
import AVFoundation

class THSpeechController: NSObject {
    
    var synthesizer:AVSpeechSynthesizer
    
    var voices:Array<AVSpeechSynthesisVoice>
    
    lazy var speechStrings = ["Hello AV Foundation. How Are you?",
                              "I am well！Thanks for asking",
                              "Are you excited about the book ?",
                              "Very! I have always felt so misunderstood",
                              "Oh,they are all my babies. I could not possibly choose.",
                              "It was great to speak with you!",
                              "The pleasure was all mine! Have fun!"
                              ]
    
    
    func speechController() -> (THSpeechController) {
        return THSpeechController.init()
    }
    
    func beginConversation()  {
        for index in 0...self.speechStrings.count-1 {
          
            let utterance = AVSpeechUtterance.init(string: self.speechStrings[index])
            print("index:\(index) speechString:\(self.speechStrings[index])")
            utterance.voice = (self.voices[index % 2] )
            utterance.rate = 0.4
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.1
            self.synthesizer.speak(utterance)
        }
    }
    
    override init() {
        self.synthesizer = AVSpeechSynthesizer()
        self.voices = [AVSpeechSynthesisVoice.init(language: "en-US")!,
                       AVSpeechSynthesisVoice.init(language: "en-GB")!]
        super.init()
    }
}
