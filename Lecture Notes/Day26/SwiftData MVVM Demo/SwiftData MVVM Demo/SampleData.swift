//
//  SampleData.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import Foundation

// In this sample data, Item represents a tool, DependentItems are materials
// the tool is made from, and IndependentItems are colors of the tool.

let sampleItems = [
    Item(
        title: "Wrench",
        dependentItems: [
            DependentItem(title: "Metal")
        ],
        independentItems: []
    ),
    Item(
        title: "Hammer",
        dependentItems: [
            DependentItem(title: "Rubber"),
            DependentItem(title: "Metal")
        ],
        independentItems: []
    ),
    Item(
        title: "Needle",
        dependentItems: [
            DependentItem(title: "Metal")
        ],
        independentItems: []
    ),
    Item(
        title: "Level",
        dependentItems: [
            DependentItem(title: "Metal"),
            DependentItem(title: "Plastic"),
            DependentItem(title: "Liquid"),
            DependentItem(title: "Paint")
        ],
        independentItems: []
    ),
]

let sampleIndependentItems = [
    IndependentItem(title: "Clear"),
    IndependentItem(title: "Red"),
    IndependentItem(title: "Blue"),
    IndependentItem(title: "Black"),
    IndependentItem(title: "Yellow"),
    IndependentItem(title: "Silver"),
    IndependentItem(title: "Brown")
]

// Here are the many-to-many associations we'll add after creating the
// underlying records (Items and IndependentItems).

let sampleAssociations = [
    ("Wrench", "Silver"),
    ("Hammer", "Silver"),
    ("Hammer", "Black"),
    ("Needle", "Silver"),
    ("Level", "Silver"),
    ("Level", "Clear"),
    ("Level", "Red"),
    ("Level", "Yellow")
]
