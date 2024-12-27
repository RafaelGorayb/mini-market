import SwiftUI
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignUp = false
    @State private var currentNonce: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Mini Market")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Senha", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button(action: {
                            Task {
                                await viewModel.signIn()
                            }
                        }) {
                            Text("Entrar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(orange1)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                Text("ou continue com")
                    .foregroundColor(.gray)
                
                VStack(spacing: 20) {
                    // Google Sign In
                    Button(action: {
                        viewModel.signInWithGoogle()
                    }) {
                        Image("google-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    
                    // Apple Sign In
                    SignInWithAppleButton { request in
                        let nonce = viewModel.randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = viewModel.sha256(nonce)
                    } onCompletion: { result in
                        viewModel.handleSignInWithAppleResult(result, nonce: currentNonce)
                    }
                    .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Button("Criar uma conta") {
                    showSignUp = true
                }
                .foregroundColor(.blue)
            }
            .padding()
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .alert("Erro", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}


