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
                    ForEach(orderManager.orders) { order in
                        orderRow(order: order)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Meus Pedidos")
        }
    }

    @ViewBuilder
    func orderRow(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Imagens e nomes dos itens
            HStack(alignment: .center, spacing: 12) {
                // ItemImageStack para exibir imagens dos itens
                ItemImageStack(items: order.orderdetails.map { $0.item })
                    .frame(width: 60, height: 60)

                VStack(alignment: .leading, spacing: 4) {
                    // Nomes dos itens
                    let itemNames = order.orderdetails.map { $0.item.name }
                    let displayedNames = itemNames.prefix(3).joined(separator: ", ")
                    Text(displayedNames)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    // "+ N itens" se houver mais de 3 itens
                    if itemNames.count > 3 {
                        Text("+ \(itemNames.count - 3) itens")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    // Mensagem de status
                    Text(orderStatusMessage(for: order.status))
                        .font(.subheadline)
                        .foregroundColor(order.status.color)
                }
            }


            // Botão "Ler QRCode"
            NavigationLink(destination: QRCodeReaderView(order: order).environmentObject(orderManager)) {
                Label("Ler QRCode", systemImage: "qrcode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(orange1)
                    .cornerRadius(10)
                    .opacity(order.status == .returned ? 0 : 1)
            }
            .disabled(order.status == .returned || order.status == .cancelled)


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
