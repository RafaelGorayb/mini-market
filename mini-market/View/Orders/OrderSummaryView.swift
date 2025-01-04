import SwiftUI
import Stripe
import StripeApplePay
import StripePaymentsUI

struct OrderSummaryView: View {
    var order: Order
    var onDismiss: () -> Void
    @State private var selectedPaymentMethod: SavedPaymentMethod?
    @State private var showConfirmation = false
    @State var isLoading = false
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    @StateObject private var paymentViewModel = PaymentViewModel.shared
    private let authenticationController = PaymentAuthenticationController()
    @StateObject private var authService = AuthService.shared
    @State private var showAuthFlow = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Payment Method Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Método de pagamento")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            
                            if authService.isAuthenticated {
                                PaymentSelectionView(
                                    selectedPaymentMethod: $selectedPaymentMethod,
                                    customerId: authService.currentUser?.stripeCustomerId ?? ""
                                )
                            } else {
                                AuthenticationFlowView {
                                    Task {
                                        if let customerId = authService.currentUser?.stripeCustomerId {
                                            await paymentViewModel.loadPaymentMethods(for: customerId)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    
                    }
                    .padding(.vertical)
                }
                
                // Bottom Section with Total and Payment Button
                VStack{
                    // Order Summary Section
                    VStack(alignment: .leading) {
                        Text("Resumo do pedido:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack {
                            ForEach(order.orderdetails, id: \.self) { detail in
                                OrderResumeView(detail: detail)
                                
                                if detail != order.orderdetails.last {
                                    Divider()
                                       
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                    }
                    
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text(totalPrice.formatted(.currency(code: "BRL")))
                            .font(.headline)
                            
                    }
                    .padding(.vertical)
                    
                    paymentButton()

                }
                .padding()
                .background(Color(.systemBackground))
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pagamento")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showConfirmation) {
                PaymentConfirmationView(order: order, onDismiss: onDismiss)
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
    @ViewBuilder
    func paymentButton() -> some View {
        Button(action: {
            Task {
                do {
                    guard let paymentMethod = selectedPaymentMethod else { return }
                    guard let customerId = authService.currentUser?.stripeCustomerId else { return }
                    
                    let amount = Int(totalPrice * 100)
                    let success = try await paymentViewModel.processPayment(
                        amount: amount,
                        customerId: customerId,
                        paymentMethodId: paymentMethod.id,
                        authenticationContext: authenticationController
                    )
                    
                    if success {
                        // Primeiro, adiciona o pedido e aguarda a conclusão
                        await orderManager.addOrder(order)
                        
                        // Após confirmar que o pedido foi adicionado, atualiza a UI
                        await MainActor.run {
                            cartManager.items.removeAll()
                            showConfirmation = true
                        }
                    }
                } catch {
                    print("Error processing payment: \(error)")
                }
            }
        }) {
            HStack {
                if paymentViewModel.isProcessingPayment {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Pagar")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(orange1)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(selectedPaymentMethod == nil || paymentViewModel.isProcessingPayment)
        .opacity(selectedPaymentMethod == nil ? 0.5 : 1)
    }

    var totalPrice: Double {
        order.orderdetails.reduce(0) { $0 + $1.price }
    }
}


#Preview {
    OrderSummaryView(order: ordertemplate, onDismiss:({}))
        .environmentObject(CartManager())
        .environmentObject(OrderManager())
        .environmentObject(AuthService())
    
}



