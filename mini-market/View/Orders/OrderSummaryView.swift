import SwiftUI

struct OrderSummaryView: View {
    var order: Order
    var onDismiss: () -> Void
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var showConfirmation = false
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Opções de pagamento no topo
                PaymentSelectionView(selectedPaymentMethod: $selectedPaymentMethod)
                    .padding(.bottom)

                // Resumo da compra
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Resumo da Compra")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        ForEach(order.orderdetails, id: \.self) { detail in
                            OrderDetailCard(detail: detail)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                // Valor total e botão de pagamento
                VStack(spacing: 16) {
                    Divider()
                    HStack {
                        Text("Total:")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text(totalPrice.formatted(.currency(code: "BRL")))
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)

                    Button(action: {
                        showConfirmation = true
                    }) {
                        Text("Pagar agora")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(orange1)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .navigationDestination(isPresented: $showConfirmation) {
                        PaymentConfirmationView(order: order, onDismiss: onDismiss)
                            .navigationBarBackButtonHidden()
                    }
                }
                .background(Color(.systemBackground))
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumo do Pedido")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var totalPrice: Double {
        order.orderdetails.reduce(0) { $0 + $1.price }
    }
}

struct OrderDetailCard: View {
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

enum PaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "Cartão de Crédito"
    case debitCard = "Cartão de Débito"
    case pix = "Pix"
    case applePay = "Apple Pay"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .creditCard:
            return "creditcard.fill"
        case .debitCard:
            return "banknote.fill"
        case .pix:
            return "qrcode"
        case .applePay:
            return "applelogo"
        }
    }
}

struct PaymentSelectionView: View {
    @Binding var selectedPaymentMethod: PaymentMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selecione o método de pagamento")
                .font(.headline)
                .padding(.horizontal)

            ForEach(PaymentMethod.allCases) { method in
                HStack {
                    Image(systemName: selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                        .foregroundColor(selectedPaymentMethod == method ? .accentColor : .gray)

                    Image(systemName: method.iconName)
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)

                    Text(method.rawValue)
                        .foregroundColor(.primary)

                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .onTapGesture {
                    selectedPaymentMethod = method
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .background(Color(.systemBackground))
    }
}
