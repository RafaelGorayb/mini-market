//
//  ContentView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 31/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var products: ProductFetchManager
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    @State private var showOrderSummary = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView().environmentObject(products)
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)
                
                CartView(selectedTab: $selectedTab).environmentObject(cartManager)
                    .tabItem {
                        Label("Carrinho", systemImage: "cart")
                    }
                    .badge(cartManager.items.isEmpty ? 0 : cartManager.items.count)
                    .tag(1)
                
                OrdersListView().environmentObject(orderManager)
                    .tabItem { Label("Pedidos", systemImage: "list.bullet") }
                    .tag(2)
            }
            
            if !cartManager.items.isEmpty {
                CartSummaryOverlay(showOrderSummary: $showOrderSummary)
            }
        }
        .sheet(isPresented: $showOrderSummary) {
            OrderSummaryView(order: cartManager.createOrder()) {
                showOrderSummary = false
            }
            .environmentObject(cartManager)
            .environmentObject(orderManager)
        }
        .onAppear {
            products.fetchProducts(from: "M4Z82fqK4bNVCmqA7vEj")
        }
    }
}

#Preview {
    ContentView().environmentObject(CartManager()).environmentObject(OrderManager())
        .environmentObject(ProductFetchManager())
        
}
