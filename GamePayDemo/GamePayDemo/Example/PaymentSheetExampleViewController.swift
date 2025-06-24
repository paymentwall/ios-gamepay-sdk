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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // The action method for the button
    @IBAction func buttonTapped() {
        // brick
        let brickOption = BrickPaymentOption()
        brickOption.setKeys(projectKey: "7780a2d33f236b4f24623f1a103d44aa",
                            secretKey: "9d8884beeb76162785fc92639da37a33")
        // payalto
        let payAltoOption = PayAltoPaymentOption()
        var payAltoSetting = PayAltoPaymentOption.Setting()
        payAltoSetting.countryCode = "KR"
        payAltoOption.setting = payAltoSetting
        payAltoOption.setKeys(projectKey: "dea07cfb5300badc9b002009facad651",
                              secretKey: "dec31fb340f14b63b42f458431e12d12")
        
        let paymentOptions: [PaymentOption] = [brickOption, payAltoOption]
        let configuration = PaymentSheet.Configuration(paymentOptions: paymentOptions)
        configuration.merchantDisplayName = "Demo Merchant"
        configuration.environment = .production
        let payment = PaymentObject(
            itemID: UUID().uuidString,
            userID: "test-user-id",
            name: "Test",
            price: 0.99,
            currency: "USD",
            image: nil
        )
        paymentSheet = PaymentSheet(payment: payment, configuration: configuration)
        paymentSheet?.present(from: self, delegate: self)
    }
}

extension PaymentSheetExampleViewController: PaymentSheetDelegate {
    func handlePaymentResult(_ result: PaymentSheetResult) {
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
    
    func handleChargeRequest(token: BrickOTTResponse,
                             payment: PaymentObject,
                             completionHandler: @escaping (Data) -> Void) {
        var req = URLRequest(url: URL(string: "http://192.168.13.208:3000/charge")!)
        let bodyDict: [String: Any] = ["token": token.token,
                                       "email": token.email ?? "test_t3_sdk@gmail.com",
                                       "amount": payment.price,
                                       "currency": payment.currency]
        if let data = try? JSONSerialization.data(withJSONObject: bodyDict, options: []) {
            req.httpBody = data
        }
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error \(error.localizedDescription)")
                    return;
                }
                
                if let data = data {
                    completionHandler(data)
                }
            }
        }).resume()
    }
}
