//
//  THMainViewController.swift
//  AudioLooper_Swift
//
//  Created by nathan on 2020/12/25.
//

import UIKit

class THMainViewController: UIViewController,THPlayerControllerDelegate {
   
    @IBOutlet weak var playButton: THPlayButton!
    
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var rateKnob: THGreenControlKnob!
    @IBOutlet weak var panKnobs: THOrangeControlKnob!
    @IBOutlet weak var volumeKnobs: THOrangeControlKnob!
    
    let controller: THPlayerController = THPlayerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func play(_ sender: THPlayButton) {
    }
    
    @IBAction func adjustRate(_ sender: THControlKnob) {
    }
    
    @IBAction func adjustPan(_ sender: THOrangeControlKnob) {
    }
    
    @IBAction func adjusVolume(_ sender: THOrangeControlKnob) {
    }
    
    func playebackStopped() {
        
    }
    
    func playbackBegan() {
        
    }
}
