//
//  Untitled.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 04/11/24.
//

import Foundation

struct Order: Hashable, Identifiable, Codable {
    let id = UUID()
    var status: OrderStatus
    var createdAt: Date
    var updatedAt: Date
    var orderdetails: [OrderDetail]
}

struct OrderDetail: Hashable, Codable {
    var item: Item
    var quantity: Int
    var rentalDetails: Rental_date_details
    var price: Double
    var totalHours: Int
}



enum OrderStatus: String, Codable, CaseIterable {
    case processing = "Em processamento"
    case pending = "A retirar"
    case ongoing = "Em andamento"
    case returned = "Devolvido"
    case cancelled = "Cancelado"
}


let ordertemplate = Order(status: OrderStatus.pending, createdAt: Date.now, updatedAt: Date.now, orderdetails: [OrderDetail(item: Item(name: "Furadeira", quantity_info: Item_Quantity(quantity_total: 5, quantity_available: 3), description: "Furadeira elétrica para uso doméstico e profissional, ideal para diversas superfícies.", image: "drill_image", category: mini_market.Item_Category.tool, createdAt: Date.now, rating: 4, price_info: Item_Price(price_perHour: 3.0, price_discount_hours_percentage: Optional(10.0), price_perDay: 3.0, price_discount_days_percentage: Optional(15.0))), quantity: 1, rentalDetails: Rental_date_details(start_date: Date.now, check_out_date: Date.now), price: 63.0, totalHours: 21)])
