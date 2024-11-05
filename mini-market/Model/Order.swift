//
//  Untitled.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 04/11/24.
//

import Foundation

struct Order: Hashable, Identifiable {
    let id = UUID()
    var status: OrderStatus
    var createdAt: Date
    var updatedAt: Date
    var orderdetails: [OrderDetail]
}

struct OrderDetail: Hashable {
    var item: Item
    var quantity: Int
    var rentalDetails: Rental_date_details
    var price: Double
    var totalHours: Int // Adicionado
}



enum OrderStatus: String, Codable, CaseIterable {
    case processing = "Em processamento"
    case pending = "A retirar"
    case ongoing = "Em andamento"
    case returned = "Devolvido"
    case cancelled = "Cancelado"
}
