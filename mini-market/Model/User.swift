import Foundation
import FirebaseAuth
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let name: String
    let cpf: String
    let stripeCustomerId: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case cpf
        case stripeCustomerId = "stripe_customer_id"
        case createdAt = "created_at"
    }
} 
