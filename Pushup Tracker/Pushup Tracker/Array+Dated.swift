//
//  Array+Dated.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/20/23.
//

import Foundation

extension Array where Element: Dated {
    func isDateUnique(withRespectTo element: Element) -> Bool {
        var foundDate = false
        
        self.forEach { dated in
            if dated.hasSameDateAs (as: element) {
                foundDate = true
            }
        }
        
        return !foundDate
    }
}
