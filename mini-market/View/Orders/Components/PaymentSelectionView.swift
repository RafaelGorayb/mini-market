//
//  PaymentSelectionView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 22/12/24.
//

import SwiftUI
import Stripe

struct PaymentSelectionView: View {
    @Binding var selectedPaymentMethod: SavedPaymentMethod?
    @State private var savedPaymentMethods: [SavedPaymentMethod] = []
    @State private var isLoading = false
    @State private var showAddCard = false
    let customerId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selecione o método de pagamento")
                .font(.headline)
                .padding(.horizontal)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(savedPaymentMethods) { method in
                    PaymentMethodRow(method: method, isSelected: selectedPaymentMethod?.id == method.id)
                        .onTapGesture {
                            selectedPaymentMethod = method
                        }
                }
                
                Button(action: { showAddCard = true }) {
                    Label("Adicionar novo cartão", systemImage: "plus.circle")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .task {
            await loadPaymentMethods()
        }
        .sheet(isPresented: $showAddCard) {
            AddCardView(customerId: customerId)
        }
    }
    
    private func loadPaymentMethods() async {
        isLoading = true
        do {
            savedPaymentMethods = try await StripeService.shared.getCustomerPaymentMethods(customerId: customerId)
        } catch {
            print("Error loading payment methods: \(error)")
        }
        isLoading = false
    }
}

struct AddCardView: View {
    let customerId: String
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Aqui você integraria o formulário de cartão do Stripe
            // Usando o SDK do Stripe para iOS
            
            Button(action: {
                Task {
                    await addCard()
                }
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Salvar cartão")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Adicionar cartão")
    }
    
    private func addCard() async {
        isLoading = true
        do {
            let clientSecret = try await StripeService.shared.createSetupIntent(customerId: customerId)
            // Aqui você usaria o SDK do Stripe para confirmar o setupIntent
            dismiss()
        } catch {
            print("Error adding card: \(error)")
        }
        isLoading = false
    }
}
