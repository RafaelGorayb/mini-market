import Foundation
import SwiftUI

struct AddToCartView: View {
    @EnvironmentObject var cartManager: CartManager
    var item: Item

    @Binding var isPresented: Bool
    @Binding var showConfirmationAlert: Bool

    @State private var quantity: Int = 1
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var rentalDurationHours: Int = 1

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalhes do Item")) {
                    Text(item.name)
                        .font(.headline)
                }

                Section(header: Text("Quantidade")) {
                    Stepper(value: $quantity, in: 1...100) {
                        Text("\(quantity)")
                    }
                }

                Section(header: Text("Duração do Aluguel (Horas)")) {
                    Stepper(value: $rentalDurationHours, in: 1...48) {
                        Text("\(rentalDurationHours) horas")
                    }
                    .onChange(of: rentalDurationHours) { newValue in
                        endDate = Calendar.current.date(byAdding: .hour, value: newValue, to: startDate) ?? endDate
                    }
                }

                Section {
                    Button(action: {
                        let rentalDetails = Rental_date_details(start_date: startDate, check_out_date: endDate)
                        let cartItem = CartItem(item: item, quantity: quantity, rentalDetails: rentalDetails)
                        cartManager.addItem(cartItem)

                        // Fechar a folha
                        isPresented = false
                        // Exibir o popup de confirmação
                        showConfirmationAlert = true
                    }) {
                        Text("Confirmar Adição ao Carrinho")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                .padding(-20)
            }
            .navigationTitle("Adicionar ao Carrinho")
        }
    }
}

#Preview {
    AddToCartView(item: items[0], isPresented: .constant(true), showConfirmationAlert: .constant(false))
        .environmentObject(CartManager())
}
