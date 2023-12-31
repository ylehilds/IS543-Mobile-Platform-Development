//
//  CalculatorViewModel.swift
//  HW6 Calculator
//
//  Created by Lehi Alcantara on 9/27/23.
//

import Foundation

@Observable class CalculatorViewModel {
    
    var playSound = true {
        didSet {
            print("playSound \(playSound)")
        }
    }
    // MARK: - Model access
    
    //TODO: Access the value of each button from an already defined enum
    
    var soundPlayer = SoundPlayer()
    
    //MARK: - User intents
    
    func handleButtonTap() {
        if playSound {
            soundPlayer.playSound(named: "Click.m4a")
        }
        
        //TODO: handle operations buttons
        
        //TODO: handle the conctenation of numbers before operation and after operation and update the result on display
    }
}
