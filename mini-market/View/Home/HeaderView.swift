//
//  HeaderView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 01/11/24.
//

import SwiftUI

struct HeaderView: View {
    var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                // Botão do menu à esquerda
                Button(action: {
                    // Ação para o menu
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            
            Spacer()
            
            // Botão de busca à direita
            Button(action: {
                // Ação para busca
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
        }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Olá \(name)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("👋") // Emoji
                }
                
                Label("Loja 407 - Ed Primavera II", systemImage: "storefront")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing])
        .clipShape(RoundedRectangle(cornerRadius: 20))
       
    }
}

#Preview {
    HeaderView(name: "Rafael")
}
