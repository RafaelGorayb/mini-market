import Foundation
import UIKit
import Stripe

@MainActor
class PaymentViewModel: ObservableObject {
    @Published var savedPaymentMethods: [SavedPaymentMethod] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let stripeAPI = StripeAPIService.shared
    
    func loadPaymentMethods(for customerId: String) async {
        isLoading = true
        do {
            let response = try await stripeAPI.getCustomerPaymentMethods(customerId: customerId)
            savedPaymentMethods = response.paymentMethods
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func processPayment(
        amount: Int,
        customerId: String,
        paymentMethodId: String,
        authenticationContext: STPAuthenticationContext
    ) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await stripeAPI.createPaymentIntent(amount: amount, customerId: customerId)
            return try await confirmPayment(
                clientSecret: response.clientSecret,
                paymentMethodId: paymentMethodId,
                authenticationContext: authenticationContext
            )
        } catch {
            self.error = error
            throw error
        }
    }
    
    private func confirmPayment(
        clientSecret: String,
        paymentMethodId: String,
        authenticationContext: STPAuthenticationContext
    ) async throws -> Bool {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethodId
        
        return try await withCheckedThrowingContinuation { continuation in
            STPPaymentHandler.shared().confirmPayment(
                paymentIntentParams,
                with: authenticationContext
            ) { status, _, error in
                switch status {
                case .succeeded:
                    continuation.resume(returning: true)
                case .failed:
                    continuation.resume(throwing: PaymentError.failed(error))
                case .canceled:
                    continuation.resume(throwing: PaymentError.canceled)
                @unknown default:
                    continuation.resume(throwing: PaymentError.unknown)
                }
            }
        }
    }
}

enum PaymentError: LocalizedError {
    case failed(Error?)
    case canceled
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .failed(let error):
            return error?.localizedDescription ?? "Payment failed"
        case .canceled:
            return "Payment was canceled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
} 
