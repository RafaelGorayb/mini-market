import Foundation
import Stripe
import UIKit

class PaymentAuthenticationController: NSObject, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.rootViewController ?? UIViewController()
    }
} 
