//
//  StoreManager.swift
//  DreamAI
//
//  Created by iApp on 02/12/22.
//

import Foundation
import StoreKit
import SwiftyStoreKit

enum Environment {
    case sandbox
    case production
}

struct ProductModel {
    var decimalPrice: CGFloat?
    var product: SKProduct?
    var productId : String?
    var localizedPrice: String?
    var trialDays: Int?
}

struct ReceiptFields {
    var subscriptionType: String?
    var expiryDate: String?
    var purchaseDate: String?
    var userType: String?
    var trialDays: String?
    var price:String?
    var getDate: String {
        return "\(String(describing: purchaseDate))"
    }
}


class StoreManager: NSObject{
    
    static let shared = StoreManager()
    private static let secretKey = "7ebe6d2dd8e2449c87070678f784442e"

    
    var products = [ProductModel]()
    
    var receiptData = ReceiptFields()

    var enviroment = Environment.production

//    private(set) var receiptInfoValue:[String: AnyObject]?

    var currentLocaleSign : String?

    private(set) var receiptInfoValue:[String: AnyObject]?

    private(set) var productIdes = [ProductType.weekly, ProductType.monthly,ProductType.yearly]

 
    var hasProducts: Bool {
        products.count > 0
    }
    
    var alreadyPurchased: Bool {
        enviroment == .production ? self.isAllPurchased() : true
    }
    
    var isPurchased: Bool{
//        return self.isAllPurchased()
        enviroment == .production ? self.isAllPurchased() : true
    }
    
    private override init() {
        super.init()
    }
    
}

extension StoreManager {
    func setup() {
        completePendingTransections()
        retriveProduct(completion: nil)
        verifyPurchase(completion: nil)
    }
 
    //MARK: Complete Pending Transaction Method
    func completePendingTransections() {
        // check previous purchase pending
        SwiftyStoreKit.completeTransactions { (purchases) in
            Helper.dispatchMain {
                for purchase in purchases {
                    if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                        if purchase.needsFinishTransaction {
                            Helper.setBool(true, forKey: purchase.productId)
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        print("purchased: \(purchase)")
                    }
                }
            }
        }
    }
    
    //MARK: Verify Purchase Method
    func verifyPurchase(completion: ((VerifyReceiptResult) -> Void)?) {
        verifyReceipt { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                self.receiptInfoValue = receipt
                let productIds = Set(self.productIdes.map({$0.productKey}))
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    self.handlePurchasedItems(items: items, expiry: expiryDate)
                    self.logEventAfterTrialPeriod(items: items)
                    NotificationCenter.default.post(name: Notification.Name.purchaseDoneNotificationName, object: true)
                case .expired(let expiryDate, let items):
                    self.handleExpiredItmes(items: items, expiry: expiryDate)
                    NotificationCenter.default.post(name: Notification.Name.purchaseDoneNotificationName, object: false)
                case .notPurchased:
                    self.handleNotPurchased()
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
            completion?(result)
        }
    }
    
    //MARK: Verify Receipt Method
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Self.secretKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    //MARK: RETREIVE PRODUCTS FROM STORE

    private func retriveProduct(completion: ((Bool) -> Void)?) {
        let productIdes: Set<String> = Set(self.productIdes.map({$0.productKey}))
        SwiftyStoreKit.retrieveProductsInfo(productIdes) { [weak self] (result) in
            guard let self = self else { return }
            if result.retrievedProducts.count > 0 {
                self.currentLocaleSign = self.priceStringForProduct(item: result.retrievedProducts.first!)
                for product in result.retrievedProducts {
                    print("Product found with price",product.productIdentifier)
                    self.products.append(self.genrateProductDetails(product))
                }
                completion?(true)
            }
            completion?(false)
        }
    }
    
    //MARK: String Pricing For Product Method
    func priceStringForProduct(item: SKProduct) -> String? {
        let price = item.price
        if price == NSDecimalNumber(decimal: 0.00) {
            return "GET" //or whatever you like really... maybe 'Free'
        } else {
            let numberFormatter = NumberFormatter()
            let locale = item.priceLocale
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = locale
            return numberFormatter.string(from: price)
        }
    }
    
    private func genrateProductDetails(_ product: SKProduct) -> ProductModel {
        var productModel = ProductModel()
        if let price  = product.localizedPrice {
            
            productModel.productId = product.productIdentifier
            productModel.localizedPrice = price
            productModel.decimalPrice = (product.price as! CGFloat) //Yearly Product 19.99
            if #available(iOS 11.2, *) {
                if let days = product.introductoryPrice?.subscriptionPeriod.numberOfUnits {
                    productModel.trialDays = days
                }
            } else {
                if product.productIdentifier == ProductType.weekly.productKey {
                    productModel.trialDays = 3
                }
            }
        }
        return productModel
    }
}

extension StoreManager{
    
    
    //MARK: Purchase Product Methods
    func purchaseProduct(productType: ProductType, complition: @escaping((Bool)->())) {
        /*self.storeModel = storeModel
        receiptData.subscriptionType = storeModel.subscriptionTypeNew
        receiptData.userType = storeModel.userType?.user
        receiptData.trialDays = storeModel.freeTrialDays
        receiptData.price = storeModel.purchasePrice*/
//        guard let productID = storeModel.productKey else { return  }
        purchaseProduct(productID: productType.productKey, complition: complition)
    }
    
   private func purchaseProduct(productID: String,complition: @escaping((Bool)->())) {
        SwiftyStoreKit.purchaseProduct(productID) {[weak self] (result) in
            Helper.dispatchMain {
                switch result {
                case .success(let purchase):
                    self?.handlePurchases(purchases: purchase, complition: complition)
//                    self?.setupRevinueLog(purchase: purchase)
                case .error(let error):
                    self?.handleErrorWhilePruchasing(error: error)
                    complition(false)
                }
            }
        }
    }
    
    //MARK:- Handle Purchases Methods
    fileprivate func handlePurchases(purchases : PurchaseDetails, complition: @escaping((Bool)->())) {
        let productID = purchases.productId
        let productfound = self.productIdes.filter({$0.productKey == productID})
        for product in productfound {
            Helper.setBool(true, forKey: product.productKey)
        }
        verifyReceipt { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                self.receiptInfoValue = receipt
                let productIds = Set( self.productIdes.map({$0.productKey}))
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    self.handlePurchasedItems(items: items, expiry: expiryDate)
                    NotificationCenter.default.post(name: NSNotification.Name.purchaseDoneNotificationName, object: true)
                    complition(true)
                case .expired(let expiryDate, let items):
                    self.handleExpiredItmes(items: items, expiry: expiryDate)
                    complition(false)
                case .notPurchased:
                    self.handleNotPurchased()
                    complition(false)
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                complition(false)
            }
        }
    }
    
    //MARK: RESTORE PREVIOUS PURCHASE METHOD
    public func restorePurchase(complition: @escaping((Bool,String)->())) {
        
        SwiftyStoreKit.restorePurchases(completion: { [weak self] (results) in
            if results.restoredPurchases.count > 0 {
//                self?.handlePurchases(purchases: results.restoredPurchases)
                self?.handlePurchases(purchases: results.restoredPurchases, completion: { [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let receipt):
//                        self.receiptInfoValue = receipt
                        let productIds = Set(self.productIdes.map({$0.productKey}))
                        let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                        switch purchaseResult {
                        case .purchased( _, _):
                            complition(true, "Products restored successfully.")
                            NotificationCenter.default.post(name: Notification.Name.purchaseDoneNotificationName, object: true)

//                            self.handlePurchasedItems(items: items, expiry: expiryDate)
//                            NotificationCenter.default.post(name: Notification.Name.purchaseDoneNotificationName, object: true)
                        case .expired( _, _):
                            complition(false, "Your subscription has been expired.")
//                            self.handleExpiredItmes(items: items, expiry: expiryDate)
//                            NotificationCenter.default.post(name: Notification.Name.purchaseDoneNotificationName, object: false)
                        case .notPurchased:
                            complition(false, "You don't have any previous purchase to restore.")
//                            self.handleNotPurchased()
                        }
                    case .error(let error):
                        print("Receipt verification failed: \(error)")
                        complition(false, error.localizedDescription)
                    }
                })
//                complition(true)
            } else {
                var errStr = ""
                for err in results.restoreFailedPurchases {
                    errStr = err.0.localizedDescription
                }
                if errStr == "" {
//                    self?.restorePurchaseDone(success: false,error : "You don't have any previous purchase to restore.")
                    return complition(false,"You don't have any previous purchase to restore.")
                }
//                self?.restorePurchaseDone(success: false,error : errStr)
                complition(false,"You don't have any previous purchase to restore.")
            }
        })
    }

    fileprivate func handlePurchases(purchases : [Purchase],completion: ((VerifyReceiptResult) -> Void)?) {
        verifyPurchase(completion: completion)
    }
}

extension StoreManager{
    //MARK:- HANDLE ERROR WHILE PURCHASING METHOD
    private func handleErrorWhilePruchasing(error: SKError) {
        print(error.errorCode,error.code)
        if error.errorCode == 2 {
            // this is authentication erroe
            // user refused to add credentials
            UIAlertController.showAlert(title: "Authentication!", message: "Authentication required to purchase the item..", actions: ["Ok":.default])
            return
        }
        UIAlertController.showAlert(title: "", message: error.localizedDescription, actions: ["Ok":.default])
    }
  /*  func logSubscription(orderId : String,price :NSDecimalNumber,currency:String){
        let dicFbEvents:[String:Any] = [AppEvents.ParameterName.orderID.rawValue: orderId,
                                        AppEvents.ParameterName.currency.rawValue: currency]
        AppEvents.logEvent(AppEvents.Name.subscribe, valueToSum: Double(truncating: price), parameters: dicFbEvents)
    }*/
    
    
    //MARK: HANDLE NOT PURCHASED METHOD
    private func handleNotPurchased() {
        for product in productIdes {
            Helper.setBool(false, forKey: product.productKey)
        }
    }
    
    //MARK: HANDLE EXPIRED ITEMS METHOD
    private func handleExpiredItmes(items:[ReceiptItem],expiry: Date) {
        for item in items {
            let purchasedProductID = item.productId
            let products = productIdes.filter({$0.productKey == purchasedProductID})
            for product in products {
                print("\(product) has been expired")
                Helper.setBool(false, forKey: product.productKey)
            }
        }
    }
    
    //MARK: handle purchased items Method
    private func handlePurchasedItems(items:[ReceiptItem],expiry: Date) {
        let filtered = items.sorted { (itemfirst, itemSecond) -> Bool in
            if itemfirst.purchaseDate > itemSecond.purchaseDate {
                return true
            }
            return false
        }
        let purchasedProductID = filtered.first?.productId
        Helper.setBool(true, forKey: purchasedProductID!)
    }
    
    
    //MARK:- Log Event After Trial Period Method
    func logEventAfterTrialPeriod(items: [ReceiptItem]) {
        let purchasedProduct = UserDefaults.standard.getPurchasedObject()
        let productIdFilter = items.filter { (item) -> Bool in
            item.productId == purchasedProduct?.purchaseId
        }
        if productIdFilter.count > 0 {
            let mostRecent = productIdFilter.reduce(productIdFilter[0], { $0.purchaseDate.timeIntervalSince1970 > $1.purchaseDate.timeIntervalSince1970 ? $0 : $1 } )
            if let trialDays = purchasedProduct?.trialDays, let days = Int(trialDays) {
                let purchasedDate = mostRecent.purchaseDate
                let interval = TimeInterval(60 * 60 * 24 * days)
                let daysAdded = purchasedDate.addingTimeInterval(interval)
                //let daysAdded = Calendar.current.date(byAdding: .day, value: days, to: purchasedDate)
                let purchasedTimeInterval = daysAdded.timeIntervalSince1970
                let todayTimeInterval = Date().timeIntervalSince1970
                if todayTimeInterval > purchasedTimeInterval {
                    // shoot FB event
                    guard let itemType = purchasedProduct?.itemType else { return  }
                    guard let itemName = purchasedProduct?.purchaseId else { return  }
                    guard let price = purchasedProduct?.price else { return  }
                    guard let locale = purchasedProduct?.locale else { return  }
                    guard let _ = purchasedProduct?.fbEventName else { return  }
                    let dicFbEvents:[String:String] = ["itemName": itemName,
                                                       "itemType": itemType]
                    print("APP EVENTS LOG PURCHASE")
                    print(dicFbEvents)
                    let updatedFBEvent = UserDefaults.standard.value(forKey: "YearlyPurchasedAfterTrial") as? Bool
                    if updatedFBEvent != true {
                        UserDefaults.standard.set(true, forKey: "YearlyPurchasedAfterTrial")
                        UserDefaults.standard.synchronize()
//                        AppEvents.logEvent(AppEvents.Name(rawValue: fbEventName))
//                        logSubscription(orderId: itemName, price:price, currency: locale)
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    var purchase = ""
                    purchase = formatter.string(from: mostRecent.purchaseDate)
                    self.receiptData.purchaseDate = purchase
//                    self.productAfterTrialPurchased(purchase: purchasedProduct!, complition: {
//                        // complition()
//                    })
                }
            }
        }
    }
}


//MARK: PURCHASED ITEM CHECK
extension StoreManager {
    
   private func isAllPurchased() -> Bool {
     
       // comment this line before submit build for TF
       let products = productIdes.filter({Helper.bool(forKey: $0.productKey) == true})
        if products.count > 0 {
            return true
        }
        return false
    }
}

//MARK:- Purchase Data Model
class PurchasedData: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(purchaseId, forKey: "purchaseId")
        coder.encode(itemType, forKey: "itemType")
        coder.encode(fbEventName, forKey: "fbEventName")
        coder.encode(trialDays, forKey: "trialDays")
        coder.encode(locale, forKey: "locale")
        coder.encode(price, forKey: "price")
        coder.encode(expiryDate, forKey: "expiryDate")
        coder.encode(purchaseDate, forKey: "purchaseDate")
    }
    
    required init?(coder: NSCoder) {
        self.purchaseId = coder.decodeObject(forKey: "purchaseId") as? String ?? ""
        self.expiryDate = coder.decodeObject(forKey: "expiryDate") as? String ?? ""
        self.purchaseDate = coder.decodeObject(forKey: "purchaseDate") as? String ?? ""
        self.itemType = coder.decodeObject(forKey: "itemType") as? String ?? ""
        self.fbEventName = coder.decodeObject(forKey: "fbEventName") as? String ?? ""
        self.trialDays = coder.decodeObject(forKey: "trialDays") as? String ?? ""
        self.locale = coder.decodeObject(forKey: "locale") as? String ?? ""
        self.price = coder.decodeObject(forKey: "price") as? NSDecimalNumber
    }
    
    var purchaseId = ""
    var expiryDate = ""
    var purchaseDate = ""
    var itemType = ""
    var fbEventName = ""
    var trialDays = ""
    var locale = ""
    var price: NSDecimalNumber?
    
    override init() {
        super.init()
    }
}


//MARK:- Store Data in User defult
extension UserDefaults {
    func setPurchasedObject(object: PurchasedData) {
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) //NSKeyedArchiver.archivedData(withRootObject: object)
            set(encodedData, forKey: "PURCHASED")
            synchronize()
        } catch let error {
            print("error to archive purchases",error.localizedDescription)
        }
        
    }

    func getPurchasedObject() -> PurchasedData? {
        var purchasedData: PurchasedData?
        do {
            guard let decodeData = data(forKey: "PURCHASED") else { return nil }
            purchasedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodeData) as? PurchasedData //unarchivedObject(ofClass: PurchasedData.self, from: decodeData)
        } catch let error {
            print("error to unarchive purchases",error.localizedDescription)
        }
        return purchasedData
    }
    
}

//MARK:- Notification Name
extension Notification.Name {
    static let purchaseDoneNotificationName = Notification.Name("on-selected-skin")
    static let kUpdateWatermarkList = Notification.Name("UpdateWatermarkList")

}

extension UIAlertController {
    
    /// - to show `alert` message
    /// - Parameters:
    ///  - title: this will be title for the alert
    ///  - actions: includes all the actions that needs to show to user
    ///  - handler: has param type `uialertaction`
    ///
    static func showAlert(title: String,message : String,actions: [String:UIAlertAction.Style] ,_ handler : ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions.sorted(by: {$0.key < $1.key}) {
            let tapAction = UIAlertAction(title: action.key, style: action.value) { (action) in
                handler?(action)
            }
            alertController.addAction(tapAction)
        }
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- UIApplication
/*extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if (base as? UIAlertController) != nil {
            return nil
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}*/

extension UIApplication {


    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

}
