//
//  mini_marketApp.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 31/10/24.
//

import SwiftUI
import Stripe
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    StripeAPI.defaultPublishableKey = "pk_test_51OHEeADfJyJBZXVvsu48lluTrteqcC9bn7JYztLh7r5FvgouHudXtIPtnUeatl3uLx2S4tJ4qvoun2UXpM09KG9o00bjPANetk"

    return true
  }
}


@main
struct mini_marketApp: App {
    // register app delegate for Firebase setup/
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var cartManager = CartManager()
    @StateObject private var orderManager = OrderManager()
    @StateObject var productManager = ProductFetchManager()
    @State private var scannedCode: String? = nil
    
    var body: some Scene {
        WindowGroup {
//            if let code = scannedCode {
                ContentView()
                    .preferredColorScheme(.light)
                    .environmentObject(cartManager)
                    .environmentObject(orderManager)
                    .environmentObject(productManager)
//            } else {
//                QrCodeStoreReader(scannedCode: $scannedCode)
//            }
        }
    }
}
