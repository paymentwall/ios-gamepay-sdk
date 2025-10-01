# iOS GamePaySDK

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [How to run Demo app](#how-to-run-demo-app)
- [Latest update](#latest-update)
- [Credentials](#credentials)
- [Core SDK integration](#core-sdk-integration)

## INTRODUCTION
Do you want to accept payments from mobile users in different countries, different payment system by writing just few of code lines?
GamePay SDK is a global mobile payment gateway that accepts payments from more than 200 countries with 100+ alternative payment options. We now provide SDK for iOS which will become a native part of your application, it eliminates the necessity to open a web browser for payments. Less steps, faster process, there’s no doubt your conversion rate will get boost! All you have to do is to integrate the framework into your project to start accepting in-app payment. It is quick and easy! We'll guide you through the process here.

## FEATURES
- Easy integration of payment gateway
- Secure payment processing
- Fully compatible with iOS applications
- Example project provided for easy setup and usage
- Many payment options supported:
    - In-app purchase: Brick, PayAlto
    - Link out payment
    
## REQUIREMENTS
XCode 16.0+, iOS 13.0+

## INSTALLATION
You can integrate the SDK into your iOS app in two simple ways:
### Swift Package Manager:
Location: https://github.com/paymentwall/ios-gamepay-sdk
Ensure to add both `GamePaySDK` & `CardinalMobile` products to your Target
### Manually (Using Pre-built xcframework)
1. Download xcframework files from github and move them to project folder
2. Open Project settings → choose `General` tab → choose `Target` → Drag xcframework file into `Frameworks and Libraries` section → choose `Embed & sign`
Ensure to add both `GamePaySDK` & `CardinalMobile` frameworks
## HOW TO RUN DEMO APP
1. To run Demo app, you need to setup a project key. Obtain these Paymentwall API credentials in the application settings of your Merchant Account at [Paymentwall.com](http://paymentwall.com/)
2. Open `GamePayDemo/GamePayDemo.xcodeproj` in Xcode
3. Modify the project and secret keys, for instance:
    ```swift
    configuration.setKeys(projectKey: projectKey, secretKey: secretKey)
    ```
4. Select `GamePayDemo` scheme then run

## LATEST UPDATE
Please check the demo app and the docs to see how to update your current code. You can check what's new on the [Release section](https://github.com/paymentwall/ios-gamepay-sdk/releases).

## CREDENTIALS
SDK integration requires a project key. Obtain these Paymentwall API credentials in the application settings of your Merchant Account at [Paymentwall.com](http://paymentwall.com/)

## Core SDK integration
For additional information, please refer to the documentation. [GamePay iOS Core SDK integration instruction](https://docs.terminal3.com/integration/sdks/game-pay-ios)
