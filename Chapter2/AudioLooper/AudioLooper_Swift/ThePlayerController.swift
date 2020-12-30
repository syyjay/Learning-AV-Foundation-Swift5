//
//  ThePlayerController.swift
//  AudioLooper
//
//  Created by nathan on 2020/12/24.
//

import UIKit
import AVFoundation
import Foundation

protocol THPlayerControllerDelegate {
    <#requirements#>
}

class THPlayerController: NSObject {
    var playing:Bool
    var players:Array<AVAudioPlayer>
    
    override init() {
        playing = false
        players = Array()
        super.init()
        
        let guitarPlayer = playerForFile(name: "guitar")
        let bassPlayer = playerForFile(name: "bass")
        let drumsPlayer = playerForFile(name: "drums")
        if guitarPlayer != nil {
            players.append(guitarPlayer!)
        }
        if bassPlayer != nil {
            players.append(bassPlayer!)
        }
        if drumsPlayer != nil {
            players.append(drumsPlayer!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    func playerForFile(name:String) -> AVAudioPlayer? {
        let player:AVAudioPlayer?
        let fileUrl = Bundle.main.url(forResource: name, withExtension: "caf")
        guard fileUrl != nil else {
            return nil
        }
        do {
            player = try AVAudioPlayer.init(contentsOf: fileUrl!)
            guard player != nil else {
                return nil
            }
            player!.numberOfLoops = -1
            player!.enableRate = true
            player!.prepareToPlay()

        } catch  {
            return nil
        }
        return player
    }
    
    func isValidIndex(index:Int) -> Bool {
        return index == 0 || index < self.players.count
    }
    
    @objc func handleInterruption(note:NSNotification) {
        let info:Dictionary = note.userInfo!
        let type:UInt = info[AVAudioSessionInterruptionTypeKey] as! UInt
        if type == AVAudioSession.InterruptionType.began.rawValue {
            //begin
        }else{
            //end
        }
    }
}

extension THPlayerController{
    
    func play() {
        if !self.playing {
            let delayTime = self.players.first!.deviceCurrentTime + 0.01
            for player in self.players {
                player.play(atTime: delayTime)
            }
            self.playing = true
        }
    }
    
    func stop() {
        if self.playing {
            for player in self.players {
                player.stop()
                player.currentTime = 0.0
            }
            self.playing = false
        }
    }
    
    func adjustRate(rate:Float) {
        for player in self.players {
            player.rate = rate
        }
    }
    
    func adjustPan(pan:Float,index:Int)  {
        if self.isValidIndex(index: index) {
            let player = self.players[index]
            player.pan = pan
        }
    }
    
    func adjustVolume(volume:Float,index:Int) {
        if self.isValidIndex(index: index) {
            let player = self.players[index]
            player.volume = volume
        }
    }
}
