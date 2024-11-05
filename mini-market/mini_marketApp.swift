//
//  mini_marketApp.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 31/10/24.
//

import SwiftUI


@main
struct mini_marketApp: App {
    @StateObject var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartManager)
        }
    }
}
