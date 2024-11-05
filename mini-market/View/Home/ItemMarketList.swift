//
//  ItemMarketList.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 01/11/24.
//

import SwiftUI

// Supondo que `Item` já é Identifiable
struct ItemMarketList: View {
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 10)
    ]
    
    @Namespace private var namespace // Namespace para a transição
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink {
                            DetailedItemMarketList(item: item, namespace: namespace)
                                .navigationTitle("Detalhes do item")
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTransition(.zoom(sourceID: item.id, in: namespace))
                        } label: {
                            ItemMarket(item: item)
                                .tint(.primary)
                                .background(Color.white)
                                .matchedTransitionSource(id: item.id, in: namespace)
                                .cornerRadius(15)
                                //.shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 4)
                               
                        }
                    }
                }
                .padding()
            }
            
        }
    }
    
    @ViewBuilder
    func ItemMarket(item: Item) -> some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "heart.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .foregroundColor(.gray).opacity(0.5)
            }
            .padding(.bottom, 5)
         
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 115)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.system(size: 13, weight: .medium))
                    Text("\(item.price_info.price_perHour.formatted(.currency(code: "BRL")))/h")
                        .font(.system(size: 12, weight: .black))
                }
                Spacer()
            }
            .padding([.leading])
            
        }
        
        .frame(height: 204)
        
        .padding(5)
        
    }
}

#Preview {
    ItemMarketList()
}