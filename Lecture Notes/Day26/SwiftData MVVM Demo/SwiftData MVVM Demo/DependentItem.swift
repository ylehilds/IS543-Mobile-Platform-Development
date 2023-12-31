//
//  DependentItem.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import Foundation
import SwiftData

@Model
final class DependentItem {
    var title: String

    // In the case of an existence-dependent item, we don't have a reference
    // back to the primary item because we'll always access it through the
    // primary item.  Compare with IndependentItem.

    init(title: String) {
        self.title = title
    }
}
