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
    @StateObject private var authService = AuthService.shared
    @State private var showAuthFlow = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
                
                if authService.isAuthenticated {
                    // Conteúdo existente do OrderSummaryView
                    PaymentSelectionView(
                        selectedPaymentMethod: $selectedPaymentMethod,
                        customerId: authService.currentUser?.stripeCustomerId ?? ""
                    )
                    .padding(.bottom)
                    
                } else {
                    // View para usuários não autenticados
                    VStack(spacing: 20) {
                        Text("Entre ou cadastre-se para continuar")
                            .font(.headline)
                        
                        Button(action: {
                            showAuthFlow = true
                        }) {
                            Text("Entrar / Cadastrar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(orange1)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
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
                                    guard let customerId = authService.currentUser?.stripeCustomerId else { return }
                                    
                                    let amount = Int(totalPrice * 100)
                                    let success = try await StripeService.shared.processPayment(
                                        amount: amount,
                                        customerId: customerId,
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
        .sheet(isPresented: $showAuthFlow) {
            AuthenticationFlowView {
                // Callback quando a autenticação for concluída
                // Aqui você pode recarregar os dados necessários
                Task {
                    if let customerId = authService.currentUser?.stripeCustomerId {
                        await loadPaymentMethods(customerId: customerId)
                    }
                }
            }
        }
    }

    private func loadPaymentMethods(customerId: String) async {
        // Implementar carregamento dos métodos de pagamento
    }

    var totalPrice: Double {
        order.orderdetails.reduce(0) { $0 + $1.price }
    }
}



