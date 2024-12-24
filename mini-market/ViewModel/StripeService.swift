import Foundation
import UIKit
import Stripe

class StripeService {
    static let shared = StripeService()
    private let baseURL = "https://stripe-payment-server.fly.dev"
    
    func createPaymentIntent(amount: Int, customerId: String) async throws -> String {
        let url = URL(string: "\(baseURL)/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "amount": amount,
            "customer": customerId
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(PaymentIntentResponse.self, from: data)
        return response.clientSecret
    }
    
    func getCustomerPaymentMethods(customerId: String) async throws -> [SavedPaymentMethod] {
        let url = URL(string: "\(baseURL)/get-payment-methods/\(customerId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PaymentMethodsResponse.self, from: data)
        return response.paymentMethods
    }
    
    func createSetupIntent(customerId: String) async throws -> String {
        let url = URL(string: "\(baseURL)/add-payment-method")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["customerId": customerId]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SetupIntentResponse.self, from: data)
        return response.clientSecret
    }
    
    func processPayment(
        amount: Int,
        customerId: String,
        paymentMethodId: String,
        authenticationContext: STPAuthenticationContext
    ) async throws -> Bool {
        // 1) Crie o PaymentIntent e obtenha o clientSecret
        let clientSecret = try await createPaymentIntent(amount: amount, customerId: customerId)
        
        // 2) Confirme o pagamento
        let result = try await confirmPayment(
            clientSecret: clientSecret,
            paymentMethodId: paymentMethodId,
            authenticationContext: authenticationContext
        )
        
        return result
    }
    
    func confirmPayment(
      clientSecret: String,
      paymentMethodId: String,
      authenticationContext: STPAuthenticationContext
    ) async throws -> Bool {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethodId
        
        return try await withCheckedThrowingContinuation { continuation in
            STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: authenticationContext) { status, _, error in
                switch status {
                case .succeeded:
                    continuation.resume(returning: true)
                case .failed:
                    continuation.resume(throwing: error ?? NSError(domain: "PaymentError", code: -1))
                case .canceled:
                    continuation.resume(throwing: NSError(domain: "PaymentError", code: -2))
                @unknown default:
                    continuation.resume(throwing: NSError(domain: "PaymentError", code: -3))
                }
            }
        }
    }


    
}

class PaymentAuthenticationController: NSObject, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.rootViewController ?? UIViewController()
    }
}


struct PaymentIntentResponse: Codable {
    let clientSecret: String
}

struct PaymentMethodsResponse: Codable {
    let paymentMethods: [SavedPaymentMethod]
}

struct SavedPaymentMethod: Codable, Identifiable {
    let id: String
    let last4: String
    let brand: String
    let expMonth: Int
    let expYear: Int
}

struct SetupIntentResponse: Codable {
    let clientSecret: String
}