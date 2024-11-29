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
    @StateObject private var orderManager = OrderManager()
    @State private var scannedCode: String? = nil
    
    var body: some Scene {
        WindowGroup {
            if let code = scannedCode {
                ContentView()
                    .environmentObject(cartManager)
                    .environmentObject(orderManager)
            } else {
                QrCodeStoreReader(scannedCode: $scannedCode)
            }
        }
    }
}
