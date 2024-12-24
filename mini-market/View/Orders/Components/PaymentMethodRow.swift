//
//  PaymentMethodRow.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 23/12/24.
//


import SwiftUI


struct PaymentMethodRow: View {
    let method: SavedPaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack {
            // Ícone da bandeira do cartão
            Image(method.brand.lowercased())
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
            
            // Informações do cartão
            VStack(alignment: .leading, spacing: 4) {
                Text(method.brand.capitalized)
                    .font(.headline)
                Text("•••• \(method.last4)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Indicador de seleção
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        )
        .padding(.horizontal)
    }
}

// Preview
struct PaymentMethodRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PaymentMethodRow(
                method: SavedPaymentMethod(
                    id: "1",
                    last4: "4242",
                    brand: "visa",
                    expMonth: 12,
                    expYear: 2024
                ),
                isSelected: true
            )
            
            PaymentMethodRow(
                method: SavedPaymentMethod(
                    id: "2",
                    last4: "5555",
                    brand: "mastercard",
                    expMonth: 8,
                    expYear: 2025
                ),
                isSelected: false
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
