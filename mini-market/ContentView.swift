//
//  ContentView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 31/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    var body: some View {
        TabView{
            HomeView()
                .tabItem{Label("Home", systemImage: "house")}
            
            CartView().environmentObject(cartManager)
                .tabItem {
                    Label("Carrinho", systemImage: "cart")                    
                }  .badge(cartManager.items.isEmpty ? 0 : cartManager.items.count)
            
            OrdersListView().environmentObject(orderManager)
                .tabItem{Label("Pedidos", systemImage: "list.bullet")}

        }
    }
}

#Preview {
    ContentView().environmentObject(CartManager()).environmentObject(OrderManager())
        
}
