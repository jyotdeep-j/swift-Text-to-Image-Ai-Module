//
//  SettingViewController.swift
//  DreamAI
//
//  Created by Pritpal Singh on 17/11/22.
//

import UIKit
import MessageUI

enum SettingType{
    case emialSupport
    case privacy
    case terms
    case darkLightTheme
    case subscriptionTerms
    case howToCreateThePerfectPrompt
//    case rightsPolicy
//    case communityGuideliness
    
    var title: String{
        switch self {
        case .emialSupport:
            return "Email Support"
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return "Terms of Service"
        case .darkLightTheme:
            return "Dark Theme"
        case .subscriptionTerms:
            return "Subscription Terms"
        case .howToCreateThePerfectPrompt:
            return "How to Create the Perfect Prompt"
//        case .rightsPolicy:
//            return "Rights Policy"
//        case .communityGuideliness:
//            return "Community Guidelines"
        }
    }
}

class SettingViewController: BaseViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    var settings:[[SettingType]] = [[.emialSupport],[.privacy,.terms],[.howToCreateThePerfectPrompt]]//[.darkLightTheme]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        settingTableView.tableFooterView = UIView()
        let theme = ThemeManager.currentTheme()
        if theme == .lightTheme {
            overrideUserInterfaceStyle = .light
        }else{
            overrideUserInterfaceStyle = .dark
        }
        
       /* if StoreManager.shared.isPurchased{
            titleHeightConstraint.constant = 0
        }*/
        
        
        //self.view.backgroundColor = UIColor.appColor(.appBackground)
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.registerTableCell(identifier: SettingTableCell.cellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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


extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: SettingTableCell.cellIdentifier, for: indexPath)as! SettingTableCell
        let setting = settings[indexPath.section][indexPath.row]
        Cell.configureCell(setting: setting, indexPath: indexPath, totalCount: settings.count)
        
      /*  Cell.titleLabel.text = settings[indexPath.section][indexPath.row].title
        if indexPath.section == 0 && indexPath.item == 0{
            Cell.cellBackgroundView.roundCorners(.allCorners, radius: 8)
        }else if indexPath.section == 1 && indexPath.item == 0{
            Cell.cellBackgroundView.roundCorners([.topLeft,.topRight], radius: 8)
        }else if indexPath.item == settings[indexPath.section].count - 1{
            Cell.cellBackgroundView.roundCorners([.bottomLeft,.bottomRight], radius: 8)
        }*/
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        61
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setting = settings[indexPath.section][indexPath.item]
        
        switch setting{
        case .emialSupport:
            supportEmail()
            break
        case .privacy,.terms,.howToCreateThePerfectPrompt:
            let webViewVC = WebViewController.initiantiate(fromAppStoryboard: .Main)
            webViewVC.settingType = setting
            self.navigationController?.pushViewController(webViewVC, animated: true)
            break
//        case .rightsPolicy:
//            break
//        case .communityGuideliness:
//            break
        case .darkLightTheme:
            break
        case .subscriptionTerms:
            break
      
        }
    }
    
    func supportEmail(){
        let deviceName = UIDevice.current.name
        print("Hello, \(deviceName)")
        let batteryLevel = UIDevice.current.batteryLevel
         print(batteryLevel)
        let systemName = UIDevice.current.systemName
        print(systemName)
//           print(UserDefaults.standard.value(forKey: "ApplicationIdentifier")!)
        let recipientEmail = "admin@memes.com"
        let subject = "Feedback for \(AppDetail.appName)"
        let body = "\n\n\nDevice Name: \(deviceName) \n System Name: \(systemName)"
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
//            
//            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//                if result == .sent{
//                    UIAlertController.alert(title: "messsage sent", message: "your messsage has been sent", viewController: self)
//                }
//               controller.dismiss(animated: true)
//            }
        }else{
            UIAlertController.alert(title: "You are not in device", message: "run on device", viewController: self)
            print("you are not in device")
        }
    }
    
        /*if indexPath.row == 0 {
            
            guard let writeReviewURL = URL(string: API.appId)
            else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            
        }
        else if  indexPath.row == 1{
            
            let deviceName = UIDevice.current.name
            print("Hello, \(deviceName)")
            let batteryLevel = UIDevice.current.batteryLevel
             print(batteryLevel)
            let systemName = UIDevice.current.systemName
            print(systemName)
               print(UserDefaults.standard.value(forKey: "ApplicationIdentifier")!)
            let recipientEmail = "test@email.com"
            let subject = "Multi client email support"
            let body = "This code supports sending email via multiple different email apps on iOS! :)"
            
            // Show default mail composer
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                
                present(mail, animated: true)
                
                
                func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                    if result == .sent{
                        UIAlertController.alert(title: "messsage sent", message: "your messsage has been sent", viewController: self)
                    }
                   controller.dismiss(animated: true)
                }
            }else{
                UIAlertController.alert(title: "You are not in device", message: "run on device", viewController: self)
                print("you are not in device")
            }
            
        }
        else if indexPath.row == 2{
            
                let webVc = storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            
            navigationController?.pushViewController(webVc, animated: true)
            
            
        }
        else if indexPath.row == 3{
            guard let writeReviewURL = URL(string: API.appId)
                   else { fatalError("Expected a valid URL") }
               UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }*/
//    }
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent{
            UIAlertController.alert(title: "Messsage sent", message: "Your messsage has been sent", viewController: self)
        }
       controller.dismiss(animated: true)
    }
}

extension UIAlertController{
    static func alert(title:String,message:String,viewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default){ (action:UIAlertAction) in
            
        })
       
        viewController.present(alert, animated: true)
    }
    
}
