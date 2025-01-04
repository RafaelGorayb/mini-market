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
        VStack(alignment: .leading) {
            HStack {
                Text(detail.item.name)
                    .font(.callout).bold()
                Spacer()
                Text("x\(detail.quantity)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Duração:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(detail.totalHours) horas")
                    .font(.caption)
            }

            HStack {
                Text("Retirada:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(detail.rentalDetails.start_date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
            }

            HStack {
                Text("Devolução:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(detail.rentalDetails.check_out_date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
            }
            HStack {
                Spacer()
                Text("\(detail.price.formatted(.currency(code: "BRL")))")
                    .font(.caption)
                    .bold()
            }
           
        }
        .background(Color.clear)
    }
}

#Preview {
    OrderResumeView(detail: ordertemplate.orderdetails[0])
}
