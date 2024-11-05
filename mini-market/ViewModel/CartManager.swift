//
//  CartManager.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 04/11/24.
//

import Foundation

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var deliveryDate: Rental_date_details?
    @Published var createdAt: Date = Date()

    init() {
        addTestItem() // Adiciona o item de teste ao iniciar o CartManager
    }

    
    // Função temporária para adicionar um item de teste ao carrinho
    func addTestItem() {
        let testItem = CartItem(
           
            item: mini_market.Item(
                name: "Furadeira",
                quantity_info: mini_market.Item_Quantity(quantity_total: 5, quantity_available: 3),
                description: "Furadeira elétrica para uso doméstico e profissional, ideal para diversas superfícies.",
                image: "drill_image",
                category: .tool,
                createdAt: Date(timeIntervalSince1970: 1709793671), // Exemplo de data fixa
                rating: 4,
                price_info: mini_market.Item_Price(
                    price_perHour: 10.0,
                    price_discount_hours_percentage: 10.0,
                    price_perDay: 50.0,
                    price_discount_days_percentage: 15.0
                )
            ),
            quantity: 1,
            rentalDetails: mini_market.Rental_date_details(
                start_date: Date(timeIntervalSince1970: 1709793675), // Exemplo de data fixa
                check_out_date: Date(timeIntervalSince1970: 1709870075)
            )
        )
        
        items.append(testItem)
    }

    
    // Função para adicionar item ao carrinho
    func addItem(_ item: CartItem) {
        items.append(item)
     
    }
    
    // Função para remover item do carrinho
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    // Função auxiliar para calcular as horas entre duas datas
    func hoursBetweenDates(start: Date, end: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: start, to: end)
        return components.hour ?? 0
    }
    
    // Função auxiliar para atualizar a data de devolução de um item
    func updateCheckOutDate(for item: CartItem, to newDate: Date) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].rentalDetails.check_out_date = newDate
        }
    }
    
    // Função para criar um pedido a partir dos itens do carrinho
    func createOrder() -> Order {
        let orderDetails = items.map { cartItem in
            let hours = hoursBetweenDates(start: cartItem.rentalDetails.start_date, end: cartItem.rentalDetails.check_out_date)
            let pricePerHour = cartItem.item.price_info.price_perHour
            let totalPrice = Double(cartItem.quantity) * Double(hours) * pricePerHour
            return OrderDetail(
                item: cartItem.item,
                quantity: cartItem.quantity,
                rentalDetails: cartItem.rentalDetails,
                price: totalPrice,
                totalHours: hours // Adicionado
            )
        }
        let order = Order(
            status: .pending,
            createdAt: Date(),
            updatedAt: Date(),
            orderdetails: orderDetails
        )
        return order
    }
    
    // Função para calcular o preço de um item do carrinho
    func calculatePrice(for cartItem: CartItem) -> Double {
        let hours = hoursBetweenDates(start: cartItem.rentalDetails.start_date, end: cartItem.rentalDetails.check_out_date)
        let pricePerHour = cartItem.item.price_info.price_perHour
        return Double(cartItem.quantity) * Double(hours) * pricePerHour
    }
    
}
