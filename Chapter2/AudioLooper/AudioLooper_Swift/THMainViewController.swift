//
//  THMainViewController.swift
//  AudioLooper_Swift
//
//  Created by nathan on 2020/12/25.
//

import UIKit

class THMainViewController: UIViewController,THPlayerControllerDelegate {
   
    @IBOutlet var rateKnob: THControlKnob!
    
    @IBOutlet weak var playButton: THPlayButton!
    
    @IBOutlet weak var playLabel: UILabel!

    
    
    @IBOutlet var panKnobs: [THControlKnob]!
    
    @IBOutlet var volumeKnobs: [THControlKnob]!
    
    
    let controller: THPlayerController = THPlayerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller.delegate = self
        
//        self.rateKnob.minimumValue = 0.5
//        self.rateKnob.maximumValue = 1.5
//        self.rateKnob.value = 1.0
//        self.rateKnob.defaultValue = 1.0
        
        
        for knob in panKnobs {
            knob.minimumValue = -1.0
            knob.maximumValue = 1.0
            knob.value = 0.0
            knob.defaultValue = 0.0
        }
        
        for knob in volumeKnobs {
            knob.minimumValue = 0.0
            knob.maximumValue = 1.0
            knob.value = 1.0
            knob.defaultValue = 1.0
        }
        
        
    }
    
    @IBAction func play(_ sender: THPlayButton) {
        if controller.playing {
            controller.play()
            playLabel.text = NSLocalizedString("Stop", comment: "")
        }else{
            controller.stop()
            playLabel.text = NSLocalizedString("Play", comment: "")
        }
        playButton.isSelected = !playButton.isSelected
    }
    
    @IBAction func adjustRate(_ sender: THControlKnob) {
        controller.adjustRate(rate: sender.value!)
    }
    
    @IBAction func adjustPan(_ sender: THOrangeControlKnob) {
        controller.adjustPan(pan: sender.value!, index: sender.tag)
    }
    
    @IBAction func adjusVolume(_ sender: THOrangeControlKnob) {
        controller.adjustVolume(volume: sender.value!, index: sender.tag)
    }
    
    func playebackStopped() {
        playButton.isSelected = false
        playLabel.text = NSLocalizedString("Play", comment: "")
    }
    
    func playbackBegan() {
        playButton.isSelected = true
        playLabel.text = NSLocalizedString("Stop", comment: "")
    }
    
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
}
