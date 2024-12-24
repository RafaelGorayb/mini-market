import SwiftUI

struct CartSummaryOverlay: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var orderManager: OrderManager
    @Binding var showOrderSummary: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(cartManager.items.count) itens no carrinho")
                        .font(.headline)
                    Text("Total: \(calculateTotal().formatted(.currency(code: "BRL")))")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button(action: {
                    showOrderSummary = true
                }) {
                    Text("Finalizar pedido")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(orange1)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .padding(.bottom, 49) // Height of TabBar
        .transition(.move(edge: .bottom))
    }
    
    private func calculateTotal() -> Double {
        cartManager.items.reduce(0) { total, item in
            total + cartManager.calculatePrice(for: item)
        }
    }
} 