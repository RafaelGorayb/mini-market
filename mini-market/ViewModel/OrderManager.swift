//
//  OrderManager.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 05/11/24.
//

import Foundation
import FirebaseFirestore
import SwiftUICore

class OrderManager: ObservableObject {
    @Published var orders: [Order] = []
    private let db = Firestore.firestore()
    @StateObject private var authService = AuthService.shared
    
    init() {
        loadUserOrders()
    }
    
    func loadUserOrders() {
        guard let userId = authService.currentUser?.id else { return }
        
        db.collection("users")
            .document(userId)
            .collection("orders")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching orders: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.orders = documents.compactMap { document in
                    try? document.data(as: Order.self)
                }
            }
    }
    
    func addOrder(_ order: Order) {
        guard let userId = authService.currentUser?.id else { return }
        
        do {
            try db.collection("users")
                .document(userId)
                .collection("orders")
                .document(order.id.uuidString)
                .setData(from: order)
            
            orders.append(order)
        } catch {
            print("Error saving order: \(error.localizedDescription)")
        }
    }
    
    func updateOrderStatus(order: Order, to newStatus: OrderStatus) {
        guard let userId = authService.currentUser?.id else { return }
        
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index].status = newStatus
            orders[index].updatedAt = Date()
            
            // Update in Firestore
            do {
                try db.collection("users")
                    .document(userId)
                    .collection("orders")
                    .document(order.id.uuidString)
                    .setData(from: orders[index])
            } catch {
                print("Error updating order status: \(error.localizedDescription)")
            }
        }
    }
}
