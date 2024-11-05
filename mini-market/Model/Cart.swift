//
//  Cart.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 04/11/24.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    var item: Item
    var quantity: Int
    var rentalDetails: Rental_date_details
}

struct Rental_date_details: Hashable {
    let start_date: Date
    var check_out_date: Date
}
