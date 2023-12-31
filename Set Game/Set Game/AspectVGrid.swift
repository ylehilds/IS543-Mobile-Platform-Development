//
//  AspectVGrid.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/26/23.
//

import SwiftUI

struct AspectVGrid<Item, ItemView> : View where Item: Identifiable, ItemView: View {
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    var items: [Item]

    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.aspectRatio = aspectRatio
        self.content = content
        self.items = items
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = calculateOptimalItemWidth(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [flexibleGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
        }
    }
    
    private func calculateOptimalItemWidth(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var rowCount = itemCount
        var columnCount = 1
        
        while columnCount < itemCount {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        }
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
    
    private func flexibleGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
}

struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        var game = SetGame()
        while game.dealtCards.count < 81 {
            game.dealCards()
        }
        let cards = game.dealtCards
        
        return AspectVGrid(
            items: cards,
            aspectRatio: 2/3
        ) { _ in RoundedRectangle(cornerRadius: 10.0).opacity(1).padding(3) }
    }
}
