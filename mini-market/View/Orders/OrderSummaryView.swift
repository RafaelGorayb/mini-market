//
//  OrderSummaryView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 05/11/24.
//

import SwiftUI

struct OrderSummaryView: View {

    var order: Order
    var onDismiss: () -> Void // Closure para fechar a sheet
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(order.orderdetails, id: \.self) { detail in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(detail.item.name)
                                    .font(.headline)
                                Text("Retirada: \(detail.rentalDetails.start_date.formatted(.dateTime.month().day().hour().minute()))")
                                    .font(.caption)
                                Text("Devolução: \(detail.rentalDetails.check_out_date.formatted(.dateTime.month().day().hour().minute()))")
                                    .font(.caption)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(detail.totalHours)h x \(detail.item.price_info.price_perHour.formatted(.currency(code: "BRL")))/h")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }

                // Seleção de pagamento
                PaymentSelectionView(selectedPaymentMethod: $selectedPaymentMethod)

                HStack {
                    Text("Total:")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text(totalPrice.formatted(.currency(code: "BRL")))
                        .font(.title2)
                        .bold()
                }
                .padding()

                Button(action: {
                    // Navegar para a tela de confirmação
                    showConfirmation = true
                }) {
                    Text("Pagar agora")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(orange1)
                        .cornerRadius(10)
                }
                .padding()
                .navigationDestination(isPresented: $showConfirmation) {
                    PaymentConfirmationView(onDismiss: onDismiss)
                }
            }
            .navigationTitle("Resumo do Pedido")
        }
    }

    var totalPrice: Double {
        order.orderdetails.reduce(0) { $0 + $1.price }
    }
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "Cartão de Crédito"
    case debitCard = "Cartão de Débito"
    case pix = "Pix"
    case applePay = "Apple Pay"

    var id: String { self.rawValue }
}


struct PaymentSelectionView: View {
    @Binding var selectedPaymentMethod: PaymentMethod

    var body: some View {
        VStack(alignment: .leading) {
            Text("Selecione o método de pagamento")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(PaymentMethod.allCases) { method in
                HStack {
                    Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                        .foregroundColor(selectedPaymentMethod == method ? .blue : .gray)
                    Text(method.rawValue)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedPaymentMethod = method
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }
}







