//
//  CartView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 04/11/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    @State private var order: Order?
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            if !cartManager.items.isEmpty {
                VStack{
                    CartListView().environmentObject(cartManager)
                    Button(action: {
                        self.order = cartManager.createOrder()
                    }) {
                        Text("Continuar para pagamento")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(orange1)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(item: $order) { order in
                        OrderSummaryView(order: order) {
                            self.order = nil
                        }
                        .environmentObject(cartManager)
                        .environmentObject(orderManager)
                    }
                }
            } else {
                EmptyCartView(selectedTab: $selectedTab)
            }
        }
    }
}

struct CartListView: View {
    @EnvironmentObject var cartManager: CartManager
    var body: some View {
        List {
            ForEach(cartManager.items) { cartItem in
                cartItemView(item: cartItem)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let item = cartManager.items[index]
                    cartManager.removeItem(item)
                }
            }
            .navigationTitle("Carrinho")
        }
    }
    @ViewBuilder
    func cartItemView(item: CartItem) -> some View {
        HStack(spacing: 10) {
            Image(item.item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 74)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(item.item.name)
                    .font(.system(size: 14, weight: .medium))
                
                Text(item.item.price_info.price_perHour.formatted(.currency(code: "BRL")))
                    .font(.system(size: 12, weight: .black))

                
                Spacer()
            }
            
            Spacer()
            
            // Terceira coluna com o Stepper para ajustar as horas
            VStack {
                HStack {
                    Text("Tempo:")
                        .font(.system(size: 14, weight: .medium))
                    
                    Text("\( cartManager.hoursBetweenDates(start: item.rentalDetails.start_date, end: item.rentalDetails.check_out_date))h")
                        .font(.system(size: 14, weight: .medium))
                }
                
                Stepper(value: Binding(
                    get: {
                        cartManager.hoursBetweenDates(start: item.rentalDetails.start_date, end: item.rentalDetails.check_out_date)
                    },
                    set: { newHours in
                        let newCheckOutDate = Calendar.current.date(byAdding: .hour, value: newHours, to: item.rentalDetails.start_date) ?? item.rentalDetails.check_out_date
                        cartManager.updateCheckOutDate(for: item, to: newCheckOutDate)
                    }
                ), in: 1...48) {
                    EmptyView() // Remove o texto padrão do Stepper
                }
            }
        }
    }
}

struct EmptyCartView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 70))
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            Text("Seu carrinho está vazio")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Explore nossos produtos e encontre o que precisa")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                selectedTab = 0 // Muda para a tab Home
            }) {
                Text("Continuar Comprando")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(orange1)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CartView(selectedTab: .constant(0)).environmentObject(CartManager())
}
