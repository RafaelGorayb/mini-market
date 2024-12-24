//
//  ItemImageStack.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 22/12/24.
//

import SwiftUI

struct ItemImageStack: View {
    var items: [Item]
    let maxImages = 3

    var body: some View {
        ZStack {
            ForEach(Array(items.prefix(maxImages).enumerated()), id: \.1.id) { index, item in
                itemImage(for: item)
                    .offset(x: CGFloat(index * -15))
            }
            if items.count > maxImages {
                extraItemsIndicator(count: items.count - maxImages)
                    .offset(x: CGFloat(maxImages * -15))
            }
        }
    }

    func itemImage(for item: Item) -> some View {
        Image(item.image)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
    }

    func extraItemsIndicator(count: Int) -> some View {
        Text("+\(count)")
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(Color.gray)
            .clipShape(Circle())
    }
}
