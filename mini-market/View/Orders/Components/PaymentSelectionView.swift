//
//  PaymentSelectionView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 22/12/24.
//

import SwiftUI
import Stripe
import StripePaymentSheet

struct PaymentSelectionView: View {
    @Binding var selectedPaymentMethod: SavedPaymentMethod?
    @StateObject private var paymentViewModel = PaymentViewModel.shared
    @State private var paymentSheet: PaymentSheet?
    let customerId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selecione o método de pagamento")
                .font(.headline)
                .padding(.horizontal)
            
            if paymentViewModel.isLoadingPaymentMethods {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(paymentViewModel.savedPaymentMethods) { method in
                    PaymentMethodRow(method: method, isSelected: selectedPaymentMethod?.id == method.id)
                        .onTapGesture {
                            selectedPaymentMethod = method
                        }
                }
                
                if let paymentSheet = paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: { result in
                            switch result {
                            case .completed:
                                    Task {
                                        await paymentViewModel.loadPaymentMethods(for: customerId)
                                    }
                                print("Payment completed")
                            case .failed(let error):
                                print("Payment failed: \(error)")
                            case .canceled:
                                print("Payment canceled")
                            }
                        }
                    ) {
                        Label("Adicionar novo cartão", systemImage: "plus.circle")
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
        }
        .task {
            await setupPaymentSheet()
        }
    }
    
    private func setupPaymentSheet() async {
        do {
            let setupIntent = try await StripeService.shared.createSetupIntent(customerId: customerId)
            
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Mini Market"
            configuration.customer = .init(id: customerId, ephemeralKeySecret: setupIntent.ephemeralKey)
            
            let paymentSheet = PaymentSheet(
                setupIntentClientSecret: setupIntent.clientSecret,
                configuration: configuration
            )
            
            DispatchQueue.main.async {
                self.paymentSheet = paymentSheet
            }
        } catch {
            print("Error setting up payment sheet: \(error)")
        }
    }
}
