//
//  OrderDetailView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 22/12/24.
//

import SwiftUI

struct OrderPostPaymentDetailView: View {
    var order: Order

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Informações gerais do pedido
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pedido #\(order.id.uuidString.prefix(6))")
                        .font(.title2)
                        .bold()
                    Text("Status: \(order.status.rawValue)")
                        .font(.headline)
                        .foregroundColor(order.status.color)
                    Text("Data: \(order.createdAt.formatted(.dateTime.day().month().year().hour().minute()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                // Lista de itens do pedido
                VStack(spacing: 12) {
                    ForEach(order.orderdetails, id: \.self) { detail in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(detail.item.name)
                                    .font(.headline)
                                Text("Quantidade: \(detail.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Horas: \(detail.totalHours)h")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(detail.price.formatted(.currency(code: "BRL")))
                                .font(.headline)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)
                    }
                }

                // Total do pedido
                HStack {
                    Text("Total:")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text(orderTotalPrice.formatted(.currency(code: "BRL")))
                        .font(.title2)
                        .bold()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle("Detalhes do Pedido")
    }

    var orderTotalPrice: Double {
        order.orderdetails.reduce(0) { $0 + $1.price }
    }
}
