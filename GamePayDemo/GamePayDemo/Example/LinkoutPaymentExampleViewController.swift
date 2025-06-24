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
    private var didHandlePaymentResult: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBuy.setTitle("Buy", for: .normal)
        btnBuy.setTitle("Transaction Processing...", for: .disabled)
    }
    
    private func doPollingToGetPaymentStatus() {
        linkOutPaymentHandler?.getPaymentStatus { [weak self] payments in
            guard let self else { return }
            
            if payments.isEmpty { // keep polling
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.doPollingToGetPaymentStatus()
                }
            } else { // show success
                showSuccessAlert()
            }
        }
    }
    
    @IBAction func onTapBuyBtn(_ sender: Any) {
        setButtonState(false)
        didHandlePaymentResult = false
        
        let userID = UUID().uuidString
        let externalID = UUID().uuidString
        let setting = LinkOutPaymentHandler.WidgetSetting(projectKey: "f4290966a50147e64836b8fdba93c48f",
                                                          secretKey: "c40a755a572eb0db8c7ae27a36e0f96d",
                                                          userId: userID,
                                                          successUrl: "gp-demo://redirect-success",
                                                          amount: 0.5,
                                                          currencyCode: "USD",
                                                          externalID: externalID,
                                                          countryCode: nil)
        self.linkOutPaymentHandler = .init(with: setting, environment: .production)
        
        self.linkOutPaymentHandler?.start { [weak self] in
            self?.showSuccessAlert()
        }
        doPollingToGetPaymentStatus()
    }
    
    private func showSuccessAlert() {
        guard !didHandlePaymentResult else { return }
        setButtonState(true)
        showAlert(title: "Transaction Result", message: "Success", completeHandler: nil)
        didHandlePaymentResult = true
    }
    
    private func setButtonState(_ isEnabled: Bool) {
        btnBuy.isEnabled = isEnabled
    }
}
