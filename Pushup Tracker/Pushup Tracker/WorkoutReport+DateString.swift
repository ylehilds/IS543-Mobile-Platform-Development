//
//  WorkoutReport+DateString.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/24/23.
//

import Foundation

extension PushupModel.WorkoutReport {
    var dateString: String {
        MediumDateFormatter.shared.string(from: date)
    }
}
