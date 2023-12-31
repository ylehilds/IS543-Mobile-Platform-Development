//
//  Catalog.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import Foundation
import SwiftData

@Model
final class Goal {
    var title: String
    var goalDescription: String
    var timePeriod: String
    var status: String
    var category: Category?
    
    init(title: String, goalDescription: String, timePeriod: String, status: String, category: Category? = nil) {
        self.title = title
        self.goalDescription = goalDescription
        self.timePeriod = timePeriod
        self.status = status
        self.category = category
    }
}

@Model
final class Category {
    @Attribute(.unique) var name: String

    @Relationship(inverse: \Goal.category)
    var goals = [Goal]()
    
    init(name: String) {
        self.name = name
    }
}

class GoalHelper {
    enum periods: String, CaseIterable, Codable {
        case daily = "Daily"
        case montly = "Monthly"
        case weekly = "Weekly"
    }
    
    enum status: String, CaseIterable, Codable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case complete = "Complete"
    }
}
