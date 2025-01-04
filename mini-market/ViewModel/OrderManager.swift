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
    private let authService = AuthService.shared
    
    init() {
        loadUserOrders()
    }
    
    func loadUserOrders() {
        guard let userId = authService.currentUser?.id else {
            print("DEBUG: No user ID found when loading orders")
            return 
        }
        
        print("DEBUG: Loading orders for user ID: \(userId)")
        
        db.collection("users")
            .document(userId)
            .collection("orders")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("DEBUG: Error fetching orders: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("DEBUG: No documents found in snapshot")
                    return
                }
                
                print("DEBUG: Found \(documents.count) orders")
                
                self?.orders = documents.compactMap { document in
                    if let order = try? document.data(as: Order.self) {
                        print("DEBUG: Successfully decoded order \(order.id)")
                        return order
                    } else {
                        print("DEBUG: Failed to decode order from document \(document.documentID)")
                        return nil
                    }
                }
                
                print("DEBUG: Final orders count: \(self?.orders.count ?? 0)")
            }
    }
    
    func addOrder(_ order: Order) async {
        guard let userId = authService.currentUser?.id else { return }
        
        do {
            // Operação assíncrona do Firestore
            try await db.collection("users")
                .document(userId)
                .collection("orders")
                .document(order.id.uuidString)
                .setData(from: order)
            
            // Atualiza a UI na thread principal
            await MainActor.run {
                orders.append(order)
            }
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
