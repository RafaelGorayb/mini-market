import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.fetchUser(userId: user.uid)
            } else {
                self?.currentUser = nil
                self?.isAuthenticated = false
                Task { @MainActor in
                    PaymentViewModel.shared.clearPaymentMethods()
                }
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, cpf: String) async throws -> User {
        // 1. Criar usuário no Firebase Auth
        let authResult = try await auth.createUser(withEmail: email, password: password)
        
        // 2. Criar customer no Stripe
        let stripeCustomerId = try await createStripeCustomer(email: email, name: name)
        
        // 3. Criar documento do usuário no Firestore
        let user = User(
            id: authResult.user.uid,
            email: email,
            name: name,
            cpf: cpf,
            stripeCustomerId: stripeCustomerId,
            createdAt: Date()
        )
        
        try await db.collection("users").document(authResult.user.uid).setData(from: user)
        
        DispatchQueue.main.async {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        await fetchUser(userId: result.user.uid)
    }
    
    // Novo método para login com credenciais (Google, Apple, etc)
    func signInWithCredential(_ credential: AuthCredential) async throws {
        let result = try await auth.signIn(with: credential)
        
        // Verifica se o usuário já existe no Firestore
        if let user = try? await db.collection("users").document(result.user.uid).getDocument().data(as: User.self) {
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
            }
        } else {
            // Se não existir, cria um novo usuário
            let stripeCustomerId = try await createStripeCustomer(
                email: result.user.email ?? "",
                name: result.user.displayName ?? "Usuário"
            )
            
            let newUser = User(
                id: result.user.uid,
                email: result.user.email ?? "",
                name: result.user.displayName ?? "Usuário",
                cpf: "", // Você pode querer solicitar o CPF posteriormente
                stripeCustomerId: stripeCustomerId,
                createdAt: Date()
            )
            
            try await db.collection("users").document(result.user.uid).setData(from: newUser)
            
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isAuthenticated = true
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser = nil
        isAuthenticated = false
    }
    
    private func fetchUser(userId: String) {
        Task {
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                let user = try document.data(as: User.self)
                
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
                
                // Only load payment methods if stripeCustomerId exists
                if let customerId = user.stripeCustomerId {
                    await PaymentViewModel.shared.loadPaymentMethods(for: customerId)
                }
            } catch {
                print("Error fetching user: \(error)")
            }
        }
    }
    
    private func createStripeCustomer(email: String, name: String) async throws -> String {
        let url = URL(string: "https://stripe-payment-server.fly.dev/create-customer")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "name": name]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(CreateCustomerResponse.self, from: data)
        return response.customerId
    }
}

struct CreateCustomerResponse: Codable {
    let customerId: String
} 