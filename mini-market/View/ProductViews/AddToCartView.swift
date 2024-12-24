import Foundation
import SwiftUI

struct AddToCartView: View {
    @EnvironmentObject var cartManager: CartManager
    var item: Item

    @Binding var isPresented: Bool
    @Binding var showConfirmationAlert: Bool

    @State private var quantity: Int = 1
    @State private var rentalDurationHours: Int = 1
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Detalhes do Item")) {
                    Text(item.name)
                        .font(.headline)
                }

                Section(header: Text("Quantidade")) {
                    Stepper(value: $quantity, in: 1...100) {
                        Text("\(quantity)")
                    }
                }

                Section(header: Text("Duração do Aluguel")) {
                    Stepper(value: $rentalDurationHours, in: 1...48) {
                        Text("\(rentalDurationHours) horas")
                    }
                }

                Section(header: Text("Data e Hora de Retirada")) {
                    DatePicker(
                        "Selecione",
                        selection: $startDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    Text("Devolução: \(calculateEndDate().formatted(date: .abbreviated, time: .shortened))")
                        .foregroundColor(.secondary)
                }
               


                Section {
                    Button(action: {
                        let rentalDetails = Rental_date_details(
                            start_date: startDate,
                            check_out_date: calculateEndDate()
                        )
                        let cartItem = CartItem(item: item, quantity: quantity, rentalDetails: rentalDetails)
                        cartManager.addItem(cartItem)

                        isPresented = false
                        showConfirmationAlert = true
                    }) {
                        Text("Confirmar Adição ao Carrinho")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(orange1)
                            .cornerRadius(10)
                    }
                }
                .padding(-20)
            }
            .navigationTitle("Adicionar ao Carrinho")
        }
    }
    
    private func calculateEndDate() -> Date {
        Calendar.current.date(byAdding: .hour, value: rentalDurationHours, to: startDate) ?? startDate
    }
}

#Preview {
    AddToCartView(item: itemsTest[0], isPresented: .constant(true), showConfirmationAlert: .constant(false))
        .environmentObject(CartManager())
}
