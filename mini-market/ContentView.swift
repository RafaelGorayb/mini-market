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
    var body: some View {
        TabView{
            HomeView()
                .tabItem{Label("Home", systemImage: "house")}
            
            CartView().environmentObject(cartManager)
                .tabItem{Label("Carrinho", systemImage: "cart")}
            
        

        }
    }
}

#Preview {
    ContentView().environmentObject(CartManager())
        
}
