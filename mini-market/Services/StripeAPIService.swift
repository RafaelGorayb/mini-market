import Foundation
import Stripe

class StripeAPIService {
    static let shared = StripeAPIService()
    private let baseURL = "https://minimarket-stripe-hgafijjn5a-rj.a.run.app"
    
    private init() {}
    
    func createPaymentIntent(amount: Int, customerId: String) async throws -> PaymentIntentResponse {
        let url = URL(string: "\(baseURL)/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["amount": amount, "customer": customerId] as [String : Any]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(PaymentIntentResponse.self, from: data)
    }
    
    func getCustomerPaymentMethods(customerId: String) async throws -> PaymentMethodsResponse {
        let url = URL(string: "\(baseURL)/get-payment-methods/\(customerId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PaymentMethodsResponse.self, from: data)
    }
    
    func createSetupIntent(customerId: String) async throws -> SetupIntentResponse {
        let url = URL(string: "\(baseURL)/create-setup-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["customerId": customerId]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(SetupIntentResponse.self, from: data)
    }
} 
