//
//  OrderListView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 05/11/24.
//

import SwiftUI

struct OrdersListView: View {
    @EnvironmentObject var orderManager: OrderManager

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    if orderManager.orders.isEmpty {
                        Text("DEBUG: No orders found")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    ForEach(orderManager.orders) { order in
                        NavigationLink(destination: OrderPostPaymentDetailView(order: order)) {
                            orderRow(order: order)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Meus Pedidos")
        }
        .onAppear {
            print("DEBUG: OrdersListView appeared with \(orderManager.orders.count) orders")
            orderManager.loadUserOrders()
        }
    }

    @ViewBuilder
    func orderRow(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with Order ID and Date
            HStack {
                Text("#\(order.id.uuidString.prefix(6))")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(order.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Items section
            HStack(alignment: .center, spacing: 12) {
                ItemImageStack(items: order.orderdetails.map { $0.item })
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 6) {
                    // Item names
                    let itemNames = order.orderdetails.map { $0.item.name }
                    let displayedNames = itemNames.prefix(2).joined(separator: ", ")
                    Text(displayedNames)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(1)
                        .truncationMode(.tail)

                    if itemNames.count > 2 {
                        Text("+ \(itemNames.count - 2) itens")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    // Pickup time for pending orders
                    if order.status == .pending, !order.orderdetails.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text("Retirar em: \(order.orderdetails[0].rentalDetails.start_date.formatted(date: .abbreviated, time: .shortened))")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.orange)
                    }
                    
                    // Status with icon
                    HStack(spacing: 4) {
                        Circle()
                            .fill(order.status.color)
                            .frame(width: 8, height: 8)
                        Text(orderStatusMessage(for: order.status))
                            .font(.system(size: 14))
                            .foregroundColor(order.status.color)
                    }
                }
            }

            // QR Code button
            if order.status != .returned && order.status != .cancelled {
                NavigationLink(destination: QRCodeReaderView(order: order).environmentObject(orderManager)) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Ler QR Code")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(orange1)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    func orderStatusMessage(for status: OrderStatus) -> String {
        switch status {
        case .processing:
            return "Seu pedido está sendo processado"
        case .pending:
            return "Aguardando retirada"
        case .ongoing:
            return "Pedido em andamento"
        case .returned:
            return "Pedido concluído"
        case .cancelled:
            return "Pedido cancelado"
        }
    }
}



#Preview {
    OrdersListView()
        .environmentObject(OrderManager()) // Certifique-se de adicionar pedidos de teste no OrderManager
}




extension OrderStatus {
    var color: Color {
        switch self {
        case .processing:
            return .yellow
        case .pending:
            return .orange
        case .ongoing:
            return .green
        case .returned:
            return .gray
        case .cancelled:
            return .red
        }
    }
}
