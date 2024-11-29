//
//  OrderManager.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 05/11/24.
//

import Foundation


class OrderManager: ObservableObject {
    @Published var orders: [Order] = []
    
    // Função para adicionar um novo pedido
    func addOrder(_ order: Order) {
        orders.append(order)
    }
    
    func updateOrderStatus(order: Order, to newStatus: OrderStatus) {
            if let index = orders.firstIndex(where: { $0.id == order.id }) {
                orders[index].status = newStatus
                orders[index].updatedAt = Date()
            }
        }
}
