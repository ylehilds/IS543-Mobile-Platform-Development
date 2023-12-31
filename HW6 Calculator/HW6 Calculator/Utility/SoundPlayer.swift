//
//  SoundPlayer.swift
//  HW6 Calculator
//
//  Created by Lehi Alcantara on 9/27/23.
//

import Foundation
import AVFoundation

struct SoundPlayer {
    var player: AVAudioPlayer?
    
    mutating func playSound(named soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            // If path not found, just fon't play it
            print("sound path not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(filePath: path))
            player?.play()
        } catch {
            // ignore -- just don't try to play the sound
        }
    }
}
