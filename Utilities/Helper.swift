//
//  Helper.swift
//  ScreenRecorder
//
//  Created by Khatib-iApp on 02/06/21.
//

import Foundation
import UIKit
import StoreKit

class Helper: NSObject{
    
    static let sharedInstance : Helper = {
        let instance = Helper()
        return instance
    }()
    
    
    var currentTimeStamp: Double{
        return Date().timeIntervalSince1970
    }
    
    
    var shouldWhyAdsPopUpShow: Bool{
        let isPopUpApper = Helper.bool(forKey: kUserDefault.whyAdsPopUpAppear)
        return !isPopUpApper
    }
    
    
    var imageCreationCountPerAppSession: Int = 0
    
    var isAppSessionCountExceedTheLimit: Bool{
        let sessionCount = Helper.value(forKey: kUserDefault.appSessionCount) as? Int ?? 1
        return sessionCount >= 4 ? true : false
    }
    
    func updateAppSessionForCustomReviewScenario(){
        if isNewSessionComplete {
            var freeTrailCount = Helper.value(forKey: kUserDefault.appSessionCount) as? Int ?? 1
            freeTrailCount += 1
            Helper.setValue(freeTrailCount, forKey: kUserDefault.appSessionCount)
        }
    }
    
    var isNewSessionComplete: Bool = false
    
    /* {
     get{
     return Helper.bool(forKey: kUserDefault.newSessionStartAfterCreation)
     }
     set{
     Helper.setBool(newValue, forKey: kUserDefault.newSessionStartAfterCreation)
     }
     }*/
    
    
    
    
    var shouldShowCustomReviewPopUp: Bool{
        if !isAppSessionCountExceedTheLimit{
            if imageCreationCountPerAppSession == 3{
                return true
            }
        }
        return false
    }
    
    //    func clearCustomReviewPopUpSenario() {
    //        Helper.setValue(0, forKey: kUserDefault.customReviewPopUpSenario)
    //    }
    
    
    /* func updateCustomReviewPopUpSenario(){
     if var freeTrailCount = Helper.value(forKey: kUserDefault.customReviewPopUpSenario) as? Int {
     freeTrailCount += 1
     Helper.setValue(freeTrailCount, forKey: kUserDefault.customReviewPopUpSenario)
     }else{
     Helper.setValue(1, forKey: kUserDefault.customReviewPopUpSenario)
     }
     }*/
    
    var isAppFreeForSave: Bool{
        return true
        
        let freeTrailCount = Helper.value(forKey: kUserDefault.freeTrailCountForSaveMedia) as? Int ?? 0
        if freeTrailCount < AppDetail.freeTrailCount{
            return true
        }else{
            return false
        }
    }
    
    func updateFreeTrailCountForCreateText2Image() {
        if var freeTrailCount = Helper.value(forKey: kUserDefault.freeTrailCountForSaveMedia) as? Int {
            freeTrailCount += 1
            Helper.setValue(freeTrailCount, forKey: kUserDefault.freeTrailCountForSaveMedia)
        }else{
            Helper.setValue(1, forKey: kUserDefault.freeTrailCountForSaveMedia)
        }
    }
    
    //MARK: Update Credit Score with Creation
    func claimedCreditScore(){
        if !StoreManager.shared.isPurchased{
            if var creditScore = Helper.value(forKey: kUserDefault.totalCreditAvailable) as? Int{
                creditScore = creditScore <= 0 ? 0 : creditScore - 1
                Helper.setValue(creditScore, forKey: kUserDefault.totalCreditAvailable)
            }
        }
    }
    
    var pendingCreditScore: Int{
        if let creditScore = Helper.value(forKey: kUserDefault.totalCreditAvailable) as? Int{
            return creditScore
        }else{
            Helper.setValue(2, forKey: kUserDefault.totalCreditAvailable)
            return 2
        }
    }
    
    //MARK:- DISPATCH METHODS
    static func dispatchDelay(deadLine: DispatchTime , execute : @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadLine, execute: execute)
    }
    
    static func  dispatchMain(execute : @escaping () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
    
    static func dispatchBackground(execute : @escaping () -> Void) {
        DispatchQueue.global().async(execute: execute)
    }
    
    static func dispatchMainAfter(time : DispatchTime , execute :@escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: time, execute: execute)
    }
    
    //MARK:- SET USERDEFAULT VALUES METHODS
    override static func setValue(_ value: Any?, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func setBool(_ value : Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    override static func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    static func bool(forKey : String) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey)
    }
    
    
    
    
    func openIAPSubscription(){
        
        Helper.dispatchMain {
            if !APIManager.shared().isInternetAvailable {
                UIAlertController.showAlert(title: "Error", message: "Check your internet connection and try again.", actions: ["OK":.default])
                return
            }
            
            if !StoreManager.shared.hasProducts {
                UIAlertController.showAlert(title: "Products Not found", message: "Store is busy loading products. Please try after sometime.", actions: ["OK":.default])
                return
            }
            
            let iapSubscriptionVC = IAPSubscriptionViewController.initiantiate(fromAppStoryboard: .Other)
            iapSubscriptionVC.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(iapSubscriptionVC, animated: true, completion: nil)
        }
        
        //        self.present(iapSubscriptionVC, animated: true)
    }
    
    // MARK: - Share Data
    
    func shareDataActivity(withImage:Bool,text:String, _ incomingImage: UIImage = UIImage()){
        var image = UIImage()
        if withImage{
            image = incomingImage
        }
        let messageStr = text
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: withImage ? text.isEmpty ? [image] : [image, messageStr] : [messageStr], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        UIApplication.topViewController()?.present(activityViewController, animated: true, completion: nil)
        
    }
    
    //MARK: - Generate Tiny URL
    
    func shortenURL(URLToSorten:String, _ completion: @escaping (_ finalURL: String?) -> ())  {
        
        if verifyUrl(urlString:URLToSorten) != false{
            DispatchQueue.global().async {
                
                guard let apiEndpoint = URL(string: "http://tinyurl.com/api-create.php?url=\(URLToSorten)")else {
                    self.ErrorMessage(error:("Error: doesn't seem to be a valid URL") as String)
                    return
                }
                do {
                    let shortURL = try String(contentsOf: apiEndpoint, encoding: String.Encoding.ascii)
                    DispatchQueue.main.async {
                        completion(shortURL)
                    }
                } catch let Error{
                    self.ErrorMessage(error:Error.localizedDescription)
                    completion(URLToSorten)
                    
                }
            }
        }else{
            self.ErrorMessage(error:"\(URLToSorten) doesn't seem to be a valid URL or is blank")
            completion(URLToSorten)
        }
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func ErrorMessage(error:String) {
        let ErrorMessageAlert = UIAlertController(title:"Error", message: error, preferredStyle: UIAlertController.Style.alert)
        ErrorMessageAlert.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
        UIApplication.topViewController()?.present(ErrorMessageAlert, animated: true, completion: nil)
        print("Error:\(error)")
    }
    
}


