//
//  Item.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 31/10/24.
//

import Foundation
import SwiftUICore


struct Item: Hashable {
    let id = UUID()
    let name: String
    let quantity_info: Item_Quantity
    let description: String
    let image: String
    let category: Item_Category
    let createdAt: Date
    let rating: Int
    let price_info: Item_Price
}

struct Item_Price: Hashable {
    let price_perHour: Double
    let price_discount_hours_percentage: Double?
    let price_perDay: Double
    let price_discount_days_percentage: Double?
    
}

struct Item_Quantity: Hashable  {
    let quantity_total: Int
    let quantity_available: Int
}

enum Item_Category: String, Codable, CaseIterable {
    case all = "All"
    case tool = "Tool"
    case food = "Kitchen"
    case clothing = "Clothing"
    case electronics = "Electronics"
    case householdApliance = "Household Apliance"
    case cleaning = "Cleaning"
    case unknown = "Outros"
}

extension Item_Category {
    var iconName: String {
        switch self {
        case .all:
            return "square.grid.2x2.fill"
        case .tool:
            return "wrench.fill"
        case .food:
            return "fork.knife"
        case .clothing:
            return "tshirt.fill"
        case .electronics:
            return "desktopcomputer"
        case .householdApliance:
            return "house.fill"
        case .cleaning:
            return "broom"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
}

let organge1 = Color("#F16A26")

let items: [Item] = [
    Item(
        name: "Furadeira",
        quantity_info: Item_Quantity(quantity_total: 5, quantity_available: 3),
        description: "Furadeira elétrica para uso doméstico e profissional, ideal para diversas superfícies.",
        image: "drill_image",
        category: .tool,
        createdAt: Date(),
        rating: 4,
        price_info: Item_Price(price_perHour: 3.0, price_discount_hours_percentage: 10.0, price_perDay: 50.0, price_discount_days_percentage: 15.0)
    ),
    Item(
        name: "Panela Elétrica",
        quantity_info: Item_Quantity(quantity_total: 3, quantity_available: 2),
        description: "Panela elétrica multifuncional, ótima para preparo de arroz, legumes e muito mais.",
        image: "rice_cooker_image",
        category: .food,
        createdAt: Date(),
        rating: 5,
        price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: 5.0, price_perDay: 20.0, price_discount_days_percentage: 10.0)
    ),
    Item(
        name: "Ferro de Passar",
        quantity_info: Item_Quantity(quantity_total: 4, quantity_available: 4),
        description: "Ferro a vapor ideal para tecidos delicados e roupas do dia a dia.",
        image: "iron_image",
        category: .clothing,
        createdAt: Date(),
        rating: 3,
        price_info: Item_Price(price_perHour: 3.0, price_discount_hours_percentage: nil, price_perDay: 10.0, price_discount_days_percentage: 5.0)
    ),
    Item(
        name: "Aspirador de Pó",
        quantity_info: Item_Quantity(quantity_total: 2, quantity_available: 1),
        description: "Aspirador de pó potente para limpeza de carpetes, estofados e superfícies variadas.",
        image: "vacuum_image",
        category: .cleaning,
        createdAt: Date(),
        rating: 4,
        price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: 5.0, price_perDay: 30.0, price_discount_days_percentage: 10.0)
    ),
    Item(
        name: "Projetor",
        quantity_info: Item_Quantity(quantity_total: 1, quantity_available: 1),
        description: "Projetor HD portátil ideal para apresentações e sessões de cinema em casa.",
        image: "projector_image",
        category: .electronics,
        createdAt: Date(),
        rating: 5,
        price_info: Item_Price(price_perHour: 5.0, price_discount_hours_percentage: 10.0, price_perDay: 70.0, price_discount_days_percentage: 20.0)
    ),
    Item(
          name: "Alicate Universal",
          quantity_info: Item_Quantity(quantity_total: 6, quantity_available: 4),
          description: "Alicate universal com cabo emborrachado, ideal para uso geral em eletrônica e mecânica.",
          image: "pliers_image",
          category: .tool,
          createdAt: Date(),
          rating: 4,
          price_info: Item_Price(price_perHour: 0.5, price_discount_hours_percentage: nil, price_perDay: 8.0, price_discount_days_percentage: 5.0)
      ),
      Item(
          name: "Chave de Fenda",
          quantity_info: Item_Quantity(quantity_total: 10, quantity_available: 7),
          description: "Chave de fenda de precisão para reparos e ajustes em eletrônicos e pequenos componentes.",
          image: "screwdriver_image",
          category: .tool,
          createdAt: Date(),
          rating: 3,
          price_info: Item_Price(price_perHour: 0.5, price_discount_hours_percentage: nil, price_perDay: 5.0, price_discount_days_percentage: nil)
      ),
      Item(
          name: "Martelo de Borracha",
          quantity_info: Item_Quantity(quantity_total: 3, quantity_available: 2),
          description: "Martelo de borracha ideal para montagem de móveis e uso em materiais delicados.",
          image: "rubber_hammer_image",
          category: .tool,
          createdAt: Date(),
          rating: 4,
          price_info: Item_Price(price_perHour: 0.5, price_discount_hours_percentage: 5.0, price_perDay: 12.0, price_discount_days_percentage: 10.0)
      ),
      Item(
          name: "Chave Inglesa",
          quantity_info: Item_Quantity(quantity_total: 5, quantity_available: 3),
          description: "Chave inglesa ajustável para diferentes tamanhos de parafusos e porcas.",
          image: "wrench_image",
          category: .tool,
          createdAt: Date(),
          rating: 4,
          price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: nil, price_perDay: 7.0, price_discount_days_percentage: 5.0)
      ),
      Item(
            name: "Escova de Cabelo Rotativa",
            quantity_info: Item_Quantity(quantity_total: 4, quantity_available: 3),
            description: "Escova rotativa com tecnologia de secagem e modelagem simultânea, ideal para penteados rápidos.",
            image: "rotating_hair_brush_image",
            category: .unknown,
            createdAt: Date(),
            rating: 5,
            price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: nil, price_perDay: 15.0, price_discount_days_percentage: 10.0)
        ),
        Item(
            name: "Chapinha",
            quantity_info: Item_Quantity(quantity_total: 3, quantity_available: 2),
            description: "Chapinha de alta performance com ajuste de temperatura, ideal para alisar e modelar.",
            image: "flat_iron_image",
            category: .unknown,
            createdAt: Date(),
            rating: 5,
            price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: 5.0, price_perDay: 20.0, price_discount_days_percentage: 15.0)
        ),
        Item(
            name: "Modelador de Cachos",
            quantity_info: Item_Quantity(quantity_total: 2, quantity_available: 1),
            description: "Modelador de cachos automático, ideal para criar cachos definidos e de longa duração.",
            image: "curling_iron_image",
            category: .unknown,
            createdAt: Date(),
            rating: 4,
            price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: nil, price_perDay: 25.0, price_discount_days_percentage: 10.0)
        ),
        Item(
            name: "Secador de Cabelo",
            quantity_info: Item_Quantity(quantity_total: 5, quantity_available: 4),
            description: "Secador de cabelo potente com múltiplas opções de temperatura e jato frio.",
            image: "hair_dryer_image",
            category: .unknown,
            createdAt: Date(),
            rating: 4,
            price_info: Item_Price(price_perHour: 2.0, price_discount_hours_percentage: nil, price_perDay: 12.0, price_discount_days_percentage: 5.0)
        )
    
]

