//
//  OrderConfirmationView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 05/11/24.
//

import SwiftUI

struct PaymentConfirmationView: View {
    var order: Order
    var onDismiss: () -> Void
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(width: 100, height: 100)
            Text("Pagamento Confirmado!")
                .font(.largeTitle)
                .bold()
            Text("Seu pedido foi processado e confirmado com sucesso.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                orderManager.addOrder(order)
                cartManager.items.removeAll()
                onDismiss()
            }) {
                Text("Concluir")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(orange1)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}



//#Preview {
//    PaymentConfirmationView(onDismiss: <#() -> Void#>)
//}
