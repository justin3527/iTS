//
//  BackgroundTask.swift
//  iTS
//
//  Created by naver on 2017. 12. 5..
//  Copyright © 2017년 xindawn. All rights reserved.
//

import Foundation
import AVFoundation
@objc(BackgroundTask)
class BackgroundTask :NSObject{
    
    var player = AVAudioPlayer()
    var timer = Timer()
    
    func startBackgroundTask() {
        NotificationCenter.default.addObserver(self, selector: #selector(interuptedAudio), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        self.playAudio()
    }
    
    func stopBackgroundTask() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        player.stop()
    }
    
    @objc private func interuptedAudio(notification: NSNotification) {
        if notification.name == NSNotification.Name.AVAudioSessionInterruption && notification.userInfo != nil {
            var info = notification.userInfo!
            var intValue = 0
            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
            if intValue == 1 { playAudio() }
        }
    }
    
    private func playAudio() {
        do {
            let bundle = Bundle.main.path(forResource: "3", ofType: "wav")
            let alertSound = NSURL(fileURLWithPath: bundle!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            try self.player = AVAudioPlayer(contentsOf: alertSound as URL)
            self.player.numberOfLoops = -1
            self.player.volume = 0.01
            self.player.prepareToPlay()
            self.player.play()
        } catch { print(error) }
    }
}
