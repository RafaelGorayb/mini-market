//
//  SideMenuView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 28/11/24.
//

// SideMenuView.swift

import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @StateObject private var authService = AuthService.shared
    @State private var showAuthFlow = false
    
    // Função para gerar feedback háptico
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare() // Prepara o gerador para reduzir latência
        generator.impactOccurred()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Profile Section
                if authService.isAuthenticated, let user = authService.currentUser {
                    VStack(alignment: .leading, spacing: 8) {
                        // User Avatar/Circle with Initials
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(user.name.prefix(1)))
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                        
                        // User Info
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Divider()
                    
                    // Menu Items
                    Button(action: {
                        // Navegar para perfil
                    }) {
                        Label("Meu Perfil", systemImage: "person")
                            .foregroundColor(.primary)
                            .padding()
                    }
                    
                    Button(action: {
                        try? authService.signOut()
                        isMenuOpen = false
                    }) {
                        Label("Sair", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                } else {
                    // Login Button for non-authenticated users
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bem-vindo!")
                            .font(.headline)
                            .padding()
                        
                        Button(action: {
                            showAuthFlow = true
                        }) {
                            Label("Entrar / Cadastrar", systemImage: "person.circle")
                                .foregroundColor(.primary)
                                .padding()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .frame(width: 250)
        .background(Color(.systemBackground))
        .sheet(isPresented: $showAuthFlow) {
            AuthenticationFlowView {
                // Callback when authentication is completed
                isMenuOpen = false
            }
        }
        .onAppear {
            generateHapticFeedback()
        }
        .onChange(of: isMenuOpen) { newValue in
            if !newValue { // Quando o menu está fechando
                generateHapticFeedback()
            }
        }
        
    }
}

#Preview {
    SideMenuView(isMenuOpen: .constant(true))
}
