//
//  OrderResumeView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 22/12/24.
//

import SwiftUI

struct OrderResumeView: View {
    var detail: OrderDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(detail.item.name)
                    .font(.headline)
                Spacer()
                Text("x\(detail.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Duração:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(detail.totalHours) horas")
                    .font(.subheadline)
            }

            HStack {
                Text("Retirada:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(detail.rentalDetails.start_date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }

            HStack {
                Text("Devolução:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(detail.rentalDetails.check_out_date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }

            HStack {
                Spacer()
                Text("Subtotal: \(detail.price.formatted(.currency(code: "BRL")))")
                    .font(.subheadline)
                    .bold()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

#Preview {
    OrderResumeView(detail: ordertemplate.orderdetails[0])
}
