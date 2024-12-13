//
//  HomeView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 01/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: Item_Category? = .all
    @State private var isMenuOpen: Bool = false

    var body: some View {
        ZStack {
            // Conteúdo principal
            NavigationStack {
                ScrollView {
                    HeaderView(name: "Rafael", isMenuOpen: $isMenuOpen)
                    CategoriesCarrousel(selectedCategory: $selectedCategory)
                        .padding(15)
                    ItemMarketList(selectedCategory: selectedCategory)
                }
                .background(Color.gray.opacity(0.1))
            }
            .offset(x: isMenuOpen ? 250 : 0)
            .disabled(isMenuOpen)

            // Fundo semitransparente para fechar o menu
            if isMenuOpen {
                Color.black.opacity(isMenuOpen ? 0.3 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isMenuOpen = false
                        }
                    }
            }

            // Menu lateral
            if isMenuOpen {
                HStack(spacing: 0){
                    SideMenuView(isMenuOpen: $isMenuOpen)
                        .frame(maxWidth: 250, maxHeight: .infinity) // Ocupa toda a altura
                    Spacer()
                }
                .zIndex(1) // Garantir que o menu esteja acima
                .transition(.move(edge: .leading)) // Transição correta
                
            }
        }
        .animation(.smooth(duration: 0.15), value: isMenuOpen)
    }
}

#Preview {
    HomeView()
}

