//
//  PaymentSheetExampleViewController.swift
//  GamePayDemo
//
//  Created by henry on 6/20/25.
//

import UIKit
import GamePaySDK

class PaymentSheetExampleViewController: UIViewController {
    private var paymentSheet: PaymentSheet?
    private let projectKey = "xxx"
    private let secretKey = "xxx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // The action method for the button
    @IBAction func buttonTapped() {
        let configuration = PaymentSheet.Configuration()
        configuration.setKeys(projectKey: projectKey,
                              secretKey: secretKey)
        configuration.merchantDisplayName = "Demo Merchant"
        configuration.merchantTermsOfServiceURL = "https://fasterpay.com/terms-of-service"
        configuration.merchantPrivacyPolicyURL = "https://fasterpay.com/privacy-policy"
        configuration.clientUrl = "gp-demo://pay-alto-redirect-success"
        let payment = PaymentObject(
            itemID: "itemID",
            userID: "userID",
            name: "Test",
            price: 10,
            currency: "USD",
            countryCode: "US",
            email: "user@mail.com",
            customParams: [:]
        )
        paymentSheet = PaymentSheet(payment: payment, configuration: configuration)
        paymentSheet?.present(from: self, delegate: self)
    }
}

extension PaymentSheetExampleViewController: PaymentSheetDelegate {
    func handlePaymentResult(_ result: GamePaySDK.PaymentResult) {
        let status: String
        switch result.status {
        case .completed:
            status = "SUCCESS"
        case .pending:
            status = "PENDING"
        case .canceled:
            status = "CANCELED"
        case .failed:
            var errorMesssage: String
            if let error = result.error,
               let gpError = error as? GPAPIClientError {
                errorMesssage = gpError.error
            } else {
                errorMesssage = result.error?.localizedDescription ?? ""
            }
            status = "ERROR: \(errorMesssage)"
        @unknown default:
            status = "UNKNOWN"
        }
        
        showAlert(title: "Payment Result",
                  message: status,
                  actionTitle: "Got it",
                  completeHandler: nil)
    }
    
    func handleChargeRequest(_ parameters: GamePaySDK.ChargeRequestParameters) {
        var req = URLRequest(url: URL(string: "http://feature-1-2-0.game-pay-demo-merchant-server.terminal3.stuffio.com/charge")!)
        var bodyDict: [String: Any?] = [
            "token": parameters.cardToken,
            "email": parameters.cardData["email"],
            "firstname": parameters.cardData["firstname"],
            "lastname": parameters.cardData["lastname"],
            "amount": parameters.payment.price,
            "currency": parameters.payment.currency,
            "secretKey": secretKey,
        ]
        if let refID = parameters.refID {
            bodyDict["reference_id"] = refID
        }
        if let secureToken = parameters.secureToken {
            bodyDict["brick_secure_token"] = secureToken
        }
        if let chargeID = parameters.chargeId {
            bodyDict["brick_charge_id"] = chargeID
        }
        if let data = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) {
            req.httpBody = data
        }
        req.httpMethod = "POST"
        req.timeoutInterval = 60
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error \(error.localizedDescription)")
                    return;
                }
                
                if let data = data {
                    parameters.completionHandler(data)
                }
            }
        }).resume()
    }
}
