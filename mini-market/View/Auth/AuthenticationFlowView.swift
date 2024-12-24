import SwiftUI

struct AuthenticationFlowView: View {
    @StateObject private var authService = AuthService.shared
    @State private var showLogin = true
    @Environment(\.dismiss) var dismiss
    let onAuthenticationComplete: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                if showLogin {
                    LoginView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancelar") {
                                    dismiss()
                                }
                            }
                        }
                } else {
                    SignUpView()
                }
                
                Button(action: {
                    showLogin.toggle()
                }) {
                    Text(showLogin ? "Não tem uma conta? Cadastre-se" : "Já tem uma conta? Entre")
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .onChange(of: authService.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                onAuthenticationComplete()
                dismiss()
            }
        }
    }
} 