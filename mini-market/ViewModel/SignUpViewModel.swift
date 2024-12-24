import Foundation

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var cpf = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    func signUp() async {
        guard validate() else { return }
        
        isLoading = true
        do {
            try await AuthService.shared.signUp(
                email: email,
                password: password,
                name: name,
                cpf: cpf
            )
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func validate() -> Bool {
        if name.isEmpty || email.isEmpty || cpf.isEmpty || password.isEmpty {
            errorMessage = "Preencha todos os campos"
            showError = true
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "As senhas não coincidem"
            showError = true
            return false
        }
        
        if password.count < 6 {
            errorMessage = "A senha deve ter pelo menos 6 caracteres"
            showError = true
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Email inválido"
            showError = true
            return false
        }
        
        if !isValidCPF(cpf) {
            errorMessage = "CPF inválido"
            showError = true
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidCPF(_ cpf: String) -> Bool {
        let numbers = cpf.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard numbers.count == 11 else { return false }
        return true // Aqui você pode adicionar uma validação mais completa do CPF
    }
} 