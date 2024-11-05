//
//  HomeView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 01/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: Item_Category?
    var body: some View {
        NavigationStack{
            ScrollView{
                HeaderView(name: "Rafael")
                CategoriesCarrousel(selectedCategory: $selectedCategory).padding(15)
                    .onTapGesture {
                        print(selectedCategory?.rawValue)
                    }
                ItemMarketList()
            }
            .background(Color.gray.opacity(0.05))
        }
    }
}

#Preview {
    HomeView()
}
