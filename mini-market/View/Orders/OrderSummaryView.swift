import SwiftUI
import Stripe
import StripeApplePay
import StripePaymentsUI


struct OrderSummaryView: View {
    var order: Order
    var onDismiss: () -> Void
    @State private var selectedPaymentMethod: SavedPaymentMethod?
    @State private var showConfirmation = false
    @State var isLoading  = false
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    private let authenticationController = PaymentAuthenticationController()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Opções de pagamento no topo
                PaymentSelectionView(selectedPaymentMethod: $selectedPaymentMethod, customerId: "cus_RS9Ixpm9Mh6QMm")
                    .padding(.bottom)

                // Resumo da compra
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Resumo da Compra")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        ForEach(order.orderdetails, id: \.self) { detail in
                            OrderResumeView(detail: detail)
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
                        Task {
                            isLoading = true
                            do {
                                guard let paymentMethod = selectedPaymentMethod else { return }
                                let amount = Int(totalPrice * 100)
                                let success = try await StripeService.shared.processPayment(
                                    amount: amount,
                                    customerId: "cus_RS9Ixpm9Mh6QMm",
                                    paymentMethodId: paymentMethod.id,
                                    authenticationContext: authenticationController
                                )
                                
                                if success {
                                    cartManager.items.removeAll()
                                    showConfirmation = true
                                }
                            } catch {
                                // Trate o erro
                                print("Error processing payment: \(error)")
                            }
                            isLoading = false
                        }
                    }, label: {
                        if isLoading{
                            ProgressView()
                        }
                        else{
                            Text("Pagar agora")
                        }
                    })

                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(orange1)
                    .cornerRadius(12)
                    .disabled(selectedPaymentMethod == nil || isLoading)
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



