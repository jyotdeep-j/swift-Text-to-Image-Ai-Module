//
//  WebViewController.swift
//  DreamAI
//
//  Created by Pritpal Singh on 17/11/22.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    var settingType: SettingType = .terms
    
    var weeklyPrice : String = "$2.99"
    @IBOutlet weak var subscriptionTermLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var policyWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionTermLabel.isHidden = true
        var fileName: String = ""
        switch settingType {
        case .howToCreateThePerfectPrompt:
            fileName = "HowToCreateThePerfectPrompt"
        case .privacy:
            fileName = "PRIVACYNOTICE_AIAPP"
        case .terms:
            fileName = "END_USER_LICENSE_AGREEMENT"
        case .subscriptionTerms:
            subscriptionTermLabel.isHidden = false
            policyWebView.isHidden = true
            subscriptionTermLabel.text = "After your 3-day free trial, this subscription automatically renews for the price of \(weeklyPrice)/Week and you may cancel at any time. Your subscription enables you to unlock all paid items and payment will be charged to your iTunes account upon confirmation of purchase. Your subscription(s) will renew automatically unless auto-renew is turned off at least 24 hours prior to the end of the current paid period and your account will be billed for renewal within 24 hours prior to the completion of the current paid period. You may toggle auto-renew on or off in your iTunes account settings at any time after purchase. Any unused portion of a free trial period, if offered, will be forfeited upon purchase of a subscription, where applicable."
        default: break
        }
        titleLabel.text = settingType.title
        
        if let docURL = Bundle.main.url(forResource: fileName, withExtension: "pdf"){
            self.policyWebView.loadFileURL(docURL, allowingReadAccessTo: docURL)
            
//            let docContents = try! Data(contentsOf: docURL)
//            let urlStr = "data:application/msword;base64," + docContents.base64EncodedString()
//            let url = URL(string: urlStr)!
//            let request = URLRequest(url: url)
//            self.policyWebView.load(request)
        }else{
            print("cannot get path")
        }
        
//        if let path = Bundle.main.path(forResource: fileName, ofType: "docx"){
//            let targetUrl: URL = URL(fileURLWithPath: path)
//            let request = URLRequest(url: targetUrl as URL)
//            policyWebView.delegate = self
//            policyWebView.scalesPageToFit = true
//            policyWebView.loadRequest(request)
//        }else{
//            print("cannot get path")
//        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonAction(_ sender: UIButton) {
        if self.presentingViewController != nil{
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
