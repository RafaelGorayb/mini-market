import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Criar Conta")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 15) {
                TextField("Nome completo", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("CPF", text: $viewModel.cpf)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Senha", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Confirmar senha", text: $viewModel.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        Task {
                            await viewModel.signUp()
                        }
                    }) {
                        Text("Criar conta")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(orange1)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button("Já tem uma conta? Entre aqui") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding()
        .alert("Erro", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
} 