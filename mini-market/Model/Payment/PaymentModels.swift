import Foundation
import Stripe

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
    let ephemeralKey: String
} 
