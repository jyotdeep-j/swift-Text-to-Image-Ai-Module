//
//  CustomReviewPopUpViewController.swift
//  DreamAI
//
//  Created by iApp on 28/11/22.
//

import UIKit


/* Review pop up sequence Update 30/11/22

App Session 1,2,3:
- After user creates their 3rd image show Custom Review only 1 time in app session
- NOTE: A creation is counted when a user Creates or Recreates

App Session 4+:
- Don’t any more review pop ups anymore

NOTE: Remove iOS review nag for now */

protocol WhyAdsInTheAppDelegate: AnyObject{
    func didTapOnWatchAdButton()
    func didTapOnRemoveAdButton()
    func didTapCancelButton()
}


class CustomReviewPopUpViewController: UIViewController {

    //MARK: Custom Review Popup View Outlets
        
    @IBOutlet weak var reviewPopUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateRequestLabel: UILabel!
    @IBOutlet weak var rateNowButton: UIButton!
    @IBOutlet weak var containerPopUpView: UIView!
    
   private let descriptionText = "This app was made by a couple of regular\nguys doing our best to give you the best\nAi experience "

    //MARK: Why Ads popUp View
    
    @IBOutlet weak var whyAdsPopUpView: UIView!
    
    @IBOutlet weak var adsMediaContainerView: UIView!
    @IBOutlet weak var whyAdsTitleLabel: UILabel!
    
    @IBOutlet weak var wePayDescriptionLabel: UILabel!
    
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var watchAdsButton: UIButton!
    
    weak var whyAdsDelegate: WhyAdsInTheAppDelegate?
    
    public var shouldShowReviewPopUpView: Bool = true
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setUpFont()
        setUpUIDesign()
        // Do any additional setup after loading the view.
    }
    
    private func setupInitialView(){
        if shouldShowReviewPopUpView{
            reviewPopUpView.isHidden = false
            whyAdsPopUpView.isHidden = true
        }else{
            reviewPopUpView.isHidden = true
            whyAdsPopUpView.isHidden = false
        }
    }
    
//MARK: Other Helper Methods
   private func setUpFont(){
       
       //Setup for Custom Review popUp
        let fontSize17 = Font(.installed(.appBold), size: .standard(.h3)).instance
        titleLabel.attributedText = titleLabel.text?.attributedTo(font: fontSize17, spacing: 0, color: UIColor.appColor(.appTextWhiteColor),alignment: .center)
        
        let fontSize16 = Font(.installed(.appRegular), size: .standard(.h3)).instance
        
//        let freeTextAttr = Font(.installed(.appBold), size: .standard(.h1)).instance
        let titleAttribute = descriptionText.attributedTo(font: fontSize16, spacing: 0, lineSpacing: 10, color: UIColor.appColor(.appTextWhiteColor),alignment: .center)
//        let titleAttribute2 = descriptionText.attri.attributedTo(font: freeTextAttr, spacing: 0, lineSpacing: 10, color: UIColor.appColor(.appTextWhiteColor),alignment: .center)
//        titleAttribute.append(titleAttribute2)
        descriptionLabel.attributedText = titleAttribute
        
        rateRequestLabel.attributedText = rateRequestLabel.text?.attributedTo(font: fontSize16, spacing: 0, lineSpacing: 10, color: UIColor.appColor(.appTextWhiteColor),alignment: .center)
       
       // Setup for Why ads popUp
       
       let whyAdsTitle23 = Font(.installed(.myRiadBold), size: .standard(.size23)).instance
       whyAdsTitleLabel.attributedText = whyAdsTitleLabel.text?.attributedTo(font: whyAdsTitle23, spacing: 1.75, color: .white,alignment: .center)
       
       wePayDescriptionLabel.attributedText = wePayDescriptionLabel.text?.attributedTo(font: fontSize16, spacing: 0.83,lineSpacing:10, color: UIColor.appColor(.appTextTitleColor),alignment: .center)
       
       let whyAdsBtn = Font(.installed(.myRiadBold), size: .standard(.h3)).instance
       let removeAttr  = removeAdsButton.currentTitle?.attributedTo(font: whyAdsBtn, spacing: 1.25, color: .white,alignment: .center)
       removeAdsButton.setAttributedTitle(removeAttr, for: .normal)
       
//       let whyAdsBtn = Font(.installed(.myRiadBold), size: .standard(.h3)).instance
       let attr  = watchAdsButton.currentTitle?.attributedTo(font: whyAdsBtn, spacing: 1.25, color: .white,alignment: .center)
       watchAdsButton.setAttributedTitle(attr, for: .normal)
       
    }
  
    private func setUpUIDesign() {
        containerPopUpView.addShadow(offset: CGSize(width: 2.5, height: 4.3),color: .black,opacity: 0.4,radius: 5)
        containerPopUpView.layer.cornerRadius = 7
        rateNowButton.layer.cornerRadius = 2
        rateNowButton.layer.masksToBounds = true
        watchAdsButton.layer.cornerRadius = 2
        removeAdsButton.layer.cornerRadius = 2
        removeAdsButton.layer.masksToBounds = true
        adsMediaContainerView.layer.cornerRadius = 7
        adsMediaContainerView.layer.masksToBounds = true
    }
   

    //MARK: UIAction Methods
    @IBAction func rateNowAction(_ sender: UIButton) {
        let urlStr = AppDetail.appStoreUrl + AppDetail.appID + "?action=write-review"
        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
        }
//        Helper.value(forKey: kUserDefault.customReviewPopUpSenario)

        Helper.setValue(true, forKey: kUserDefault.isReviewComplete)
        Helper.dispatchMainAfter(time: .now() + 0.1) {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func dismissReviewPoUp(_ sender: UIButton) {
        if whyAdsDelegate != nil{
            whyAdsDelegate?.didTapCancelButton()
        }else{
            Helper.sharedInstance.isNewSessionComplete = true
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func removeAdsAction(_ sender: UIButton) {
        Helper.setBool(true, forKey: kUserDefault.whyAdsPopUpAppear)
        
        self.dismiss(animated: true) {
            self.whyAdsDelegate?.didTapOnRemoveAdButton()
        }
    }
    
    @IBAction func watchTheAdsAction(_ sender: UIButton) {
        Helper.setBool(true, forKey: kUserDefault.whyAdsPopUpAppear)
        
        self.dismiss(animated: true) {
            self.whyAdsDelegate?.didTapOnWatchAdButton()
        }
       
//        self.dismiss(animated: true)
    }
}
