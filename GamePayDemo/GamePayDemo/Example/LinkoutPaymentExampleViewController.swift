//
//  LinkoutPaymentExampleViewController.swift
//  GamePayDemo
//
//  Created by henry on 6/20/25.
//

import UIKit
import GamePaySDK

class LinkoutPaymentExampleViewController: UIViewController {
    @IBOutlet weak var btnBuy: UIButton!
    
    private var linkOutPaymentHandler: LinkOutPaymentHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTapBuyBtn(_ sender: Any) {
        let externalID = UUID().uuidString
        let widgetSetting = LinkOutPaymentHandler.WidgetSetting(
            projectKey: "projectKey",
            secretKey: "secretKey",
            userId: "userID",
            clientUrl: "gp-demo://redirect-success",
            amount: 10,
            currencyCode: "USD",
            externalID: externalID,
            widget: "t3",
            countryCode: "USD",
            customParams: [:]
        )
        self.linkOutPaymentHandler = .init(with: widgetSetting, delegate: self)
        self.linkOutPaymentHandler?.start(from: self)
    }
}

extension LinkoutPaymentExampleViewController: PaymentDelegate {
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
}
