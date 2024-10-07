//
//  IAPSubscriptionViewController.swift
//  DreamAI
//
//  Created by iApp on 01/12/22.
//

import UIKit

class IAPSubscriptionViewController: BaseViewController {

    @IBOutlet weak var topProductListCollectionView: UICollectionView!

    @IBOutlet weak var topProductListHeightConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var gradientBlackView: UIView!
    @IBOutlet weak var makeUpToLabel: UILabel!
    @IBOutlet weak var commercialLabel: UILabel!
    @IBOutlet weak var unlockAllProLabel: UILabel!
    @IBOutlet weak var fasterProcessingLabel: UILabel!
    
    
    @IBOutlet weak var yearlyProductContainerView: UIView!
    @IBOutlet weak var yearlyEllipseImageView: UIImageView!
    @IBOutlet weak var yearlyPriceLabel: UILabel!
    
    @IBOutlet weak var monthlyProductContainerView: UIView!
    @IBOutlet weak var monthlyEllipseImageView: UIImageView!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    @IBOutlet weak var weeklyEllipseImageView: UIImageView!
    @IBOutlet weak var weeklyPriceLabel: UILabel!
    @IBOutlet weak var weeklyProductContainerView: UIView!
    @IBOutlet weak var productViewHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var termsViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var yearlyPriceBottomLabel: UILabel!
    
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var subscriptionTermsButton: UIButton!
    
    static let productArray = ["0_0 1","0_0-2 1","a character","ca3p9lcByB2IrdMOeMnK","grid_0-3 2","yobananaboy_gray","0_0 1"]
   
    var timerStore : Timer?

    var storeViewModel = StoreViewModel()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientBlackView.bounds
        //gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.9).cgColor]
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0,0.6]
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        setupUIFont()
        setupUIDesign()
        startTimerForAnimateProductWithSwipeAnimation()
        //self.startTimerForMoveStylesItemInSequence()
        setObservations()
        self.setupProduct(productType: .yearly)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = gradientBlackView.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    //MARK: UIDesign Setup Methods
    
    private func setupUIDesign() {
        continueButton.layer.cornerRadius =         continueButton.bounds.height/2
        continueButton.layer.masksToBounds = true
        
        if Devices.IS_IPHONE_6_8P || Devices.IS_IPHONE_6_8{
            topProductListHeightConstraint.constant = 210
            productViewHeightConstraint.priority = UILayoutPriority(1000)
            productViewHeightConstraint.constant = 190
//            termsViewBottomConstraint.constant = 3
        }
        
        weeklyProductContainerView.layer.cornerRadius = 10
        weeklyProductContainerView.layer.masksToBounds = true
        
        monthlyProductContainerView.layer.cornerRadius = 10
        yearlyProductContainerView.layer.cornerRadius = 10
        
        weeklyProductContainerView.backgroundColor = UIColor.appColor(.startImageBGColor)
        monthlyProductContainerView.backgroundColor = UIColor.appColor(.startImageBGColor)
        yearlyProductContainerView.backgroundColor = UIColor.appColor(.startImageBGColor)
        
        
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = gradientBlackView.bounds
//        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.9).cgColor]
//        gradientLayer.locations = [0.2,0.8]
        gradientBlackView.layer.addSublayer(self.gradientLayer)
        
        
    }
    
    private func setupUIFont(){
        
        let padaukBold = Font(.installed(.PadaukBold), size: .standard(.h1)).instance
        
        let titleAttribute = makeUpToLabel.text?.attributedTo(font: padaukBold, spacing: 0.2, color: .white,alignment: .left)
        makeUpToLabel.attributedText = titleAttribute
        
        let commercial = commercialLabel.text?.attributedTo(font: padaukBold, spacing: 0.2, color: .white,alignment: .left)
        commercialLabel.attributedText = commercial
        
        let unlockAll = unlockAllProLabel.text?.attributedTo(font: padaukBold, spacing: 0.2, color: .white,alignment: .left)
        unlockAllProLabel.attributedText = unlockAll
        
        let fasterProcessing = fasterProcessingLabel.text?.attributedTo(font: padaukBold, spacing: 0.2, color: .white,alignment: .left)
        fasterProcessingLabel.attributedText = fasterProcessing
        
        
        
//        let title20 = Font(.installed(.myRiadBold), size: .standard(.h1)).instance
        
       /* let titleAttribute = titleLabel.text?.attributedTo(font: title20, spacing: 1, color: .white,alignment: .center)
        titleLabel.attributedText = titleAttribute*/
        
//        let fontSize23 = Font(.installed(.myRiadBold), size: .standard(.size23)).instance
        /*let madePro = madeWithProLabel.text?.attributedTo(font: fontSize23, spacing: 1.16, color: .white,alignment: .center)
        madeWithProLabel.attributedText = madePro*/
        
//        let fontSize15 = Font(.installed(.myRiadRegular), size: .standard(.size15)).instance
//        let noPayment = noPaymentLabel.text?.attributedTo(font: fontSize15, spacing: 0.75, color: .white,alignment: .center)
//        noPaymentLabel.attributedText = noPayment
        
        yearlyPriceLabel.attributedText = storeViewModel.yearlyCutPrice
        monthlyPriceLabel.attributedText = storeViewModel.monthlyCutPrice
        weeklyPriceLabel.attributedText = storeViewModel.weeklyCutPrice
        
//        let fontSize25 = Font(.installed(.PadaukBold), size: .standard(.size25)).instance
//        let continueTitle =  continueButton.currentTitle?.attributedTo(font: fontSize25, spacing: 0.0, color: UIColor.appColor(.bottomViewBgColor),alignment: .center)
//        continueButton.setAttributedTitle(continueTitle, for: .normal)
        
       /* let myRiadBold = Font(.installed(.myRiadRegular), size: .standard(.h3)).instance
        let pricePerWeak = pricePerWeekLabel.text?.attributedTo(font: myRiadBold, spacing: 0.83, color: .white,alignment: .center)
        pricePerWeekLabel.attributedText = pricePerWeak*/
        
       
        
        let buttonFont = Font(.installed(.appRegular), size: .custom(12.propotionalSize)).instance
        let terms = termsButton.currentTitle?.attributedTo(font: buttonFont, spacing: 0.42, color: UIColor.appColor(.appTextGray),alignment: .center)
        termsButton.setAttributedTitle(terms, for: .normal)
        
        let policy = policyButton.currentTitle?.attributedTo(font: buttonFont, spacing: 0.42, color: UIColor.appColor(.appTextGray),alignment: .center)
        policyButton.setAttributedTitle(policy, for: .normal)
        
        let restore = restoreButton.currentTitle?.attributedTo(font: buttonFont, spacing: 0.42, color: .white,alignment: .center)
        restoreButton.setAttributedTitle(restore, for: .normal)
        let subscriptionTems = subscriptionTermsButton.currentTitle?.attributedTo(font: buttonFont, spacing: 0.42, color: UIColor.appColor(.appTextGray),alignment: .center)
        subscriptionTermsButton.setAttributedTitle(subscriptionTems, for: .normal)
    }
    
    
    //MARK: UIButton Action Methods
    
    @IBAction func monthlyProductAction(_ sender: UIButton) {
        setupProduct(productType: .monthly)
    }
    @IBAction func yearlyProductAction(_ sender: UIButton) {
        setupProduct(productType: .yearly)
    }
    @IBAction func weeklyProductAction(_ sender: UIButton) {
        setupProduct(productType: .weekly)
    }
    
    private func setupProduct(productType: ProductType){
        
        storeViewModel.didSelectProduct(product: productType)
        let fontSize25 = Font(.installed(.PadaukBold), size: .standard(.size25)).instance
        switch productType {
        case .weekly:
            yearlyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            monthlyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            weeklyEllipseImageView.image = UIImage(named: "GeeenCheck")
            
            yearlyProductContainerView.layer.borderWidth = 1
            yearlyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            
            weeklyProductContainerView.layer.borderWidth = 1
            weeklyProductContainerView.layer.borderColor = UIColor.appColor(.appGreenIAP)?.cgColor
            
            monthlyProductContainerView.layer.borderWidth = 1
            monthlyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            yearlyPriceBottomLabel.isHidden = true
            let continueTitle =  "Continue".attributedTo(font: fontSize25, spacing: 0.0, color: UIColor.appColor(.bottomViewBgColor),alignment: .center)
            continueButton.setAttributedTitle(continueTitle, for: .normal)
            break
        case .monthly:
            yearlyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            monthlyEllipseImageView.image = UIImage(named: "GeeenCheck")
            weeklyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            
            yearlyProductContainerView.layer.borderWidth = 1
            yearlyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            
            weeklyProductContainerView.layer.borderWidth = 1
            weeklyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            
            monthlyProductContainerView.layer.borderWidth = 1
            monthlyProductContainerView.layer.borderColor = UIColor.appColor(.appGreenIAP)?.cgColor
            yearlyPriceBottomLabel.isHidden = true
            let continueTitle =  "Continue".attributedTo(font: fontSize25, spacing: 0.0, color: UIColor.appColor(.bottomViewBgColor),alignment: .center)
            continueButton.setAttributedTitle(continueTitle, for: .normal)
            break
        case .yearly:
            yearlyEllipseImageView.image = UIImage(named: "GeeenCheck")
            monthlyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            weeklyEllipseImageView.image = UIImage(named: "EllipseWhiteBorder")
            
            yearlyProductContainerView.layer.borderWidth = 1
            yearlyProductContainerView.layer.borderColor = UIColor.appColor(.appGreenIAP)?.cgColor
            
            weeklyProductContainerView.layer.borderWidth = 1
            weeklyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            
            monthlyProductContainerView.layer.borderWidth = 1
            monthlyProductContainerView.layer.borderColor = UIColor.appColor(.startImageBorderColor)?.cgColor
            
            yearlyPriceBottomLabel.isHidden = false
            yearlyPriceBottomLabel.attributedText = storeViewModel.yearlyOriginalPrice
           
            let continueTitle =  "Try For Free".attributedTo(font: fontSize25, spacing: 0.0, color: UIColor.appColor(.bottomViewBgColor),alignment: .center)
            continueButton.setAttributedTitle(continueTitle, for: .normal)
            
            break
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continuePurchaseProductAction(_ sender: UIButton) {
        if !APIManager.shared().isInternetAvailable {
            UIAlertController.showAlert(title: "Failed", message: "Please check your internet connection and try again.", actions: ["Ok":.default])
            return
        }
//        Helper.sharedInstance.showIndicator()
        SwiftLoader.show(animated: true)
        // start purchase
        storeViewModel.purchaseProduct { success in
            Helper.dispatchMain {
                if success{
                    Helper.dispatchDelay(deadLine: .now() + 1.0) {
                        UIAlertController.showAlert(title: "", message: "Product Purchased Successfully.", actions: ["Ok":.default])
                    }
                }
                SwiftLoader.hide()
            }
        }
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        if !APIManager.shared().isInternetAvailable {
            UIAlertController.showAlert(title: "Failed", message: "Please check your internet connection and try again.", actions: ["Ok":.default])
            return
        }
//        Helper.sharedInstance.showIndicator()
        SwiftLoader.show(animated: true)
        storeViewModel.restorePurchase { (success, message) in
            Helper.dispatchDelay(deadLine: .now() + 0.8) {
                UIAlertController.showAlert(title: "", message: message, actions: ["Ok":.default])
            }
            Helper.dispatchMain {
//                Helper.sharedInstance.hideIndicator()
                SwiftLoader.hide()
            }
        }
    }
    
    @IBAction func termsOfUseAction(_ sender: UIButton) {
        let webViewVC = WebViewController.initiantiate(fromAppStoryboard: .Main)
        webViewVC.settingType = .terms
        webViewVC.modalPresentationStyle = .fullScreen
        self.present(webViewVC, animated: true)
//        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @IBAction func policyAction(_ sender: UIButton) {
        let webViewVC = WebViewController.initiantiate(fromAppStoryboard: .Main)
        webViewVC.settingType = .privacy
        webViewVC.modalPresentationStyle = .fullScreen
        self.present(webViewVC, animated: true)
    }
    
    
    @IBAction func subscriptionTermsAction(_ sender: UIButton) {
        let webViewVC = WebViewController.initiantiate(fromAppStoryboard: .Main)
        webViewVC.weeklyPrice = storeViewModel.weeklyPrice
        webViewVC.settingType = .subscriptionTerms
        webViewVC.modalPresentationStyle = .fullScreen
        self.present(webViewVC, animated: true)
    }
}

extension IAPSubscriptionViewController{
    
    private func setObservations() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseDone(_:)), name: Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    @objc func purchaseDone(_ notification: Notification) {
        if let isPurchased = notification.object as? Bool {
            if isPurchased {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
}


extension IAPSubscriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topProductListCollectionView{
            return Self.productArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topProductListCollectionView{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:IAPImagePreviewCollectionCell.identifier, for: indexPath) as? IAPImagePreviewCollectionCell
            cell?.configureCell(forProduct: Self.productArray[indexPath.item])
            return cell ?? UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topProductListCollectionView{
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: collectionView.bounds.height) // 1125/658
        }else{
            return CGSize(width: ScreenSize.SCREEN_WIDTH/3.5, height: collectionView.bounds.height)
        }
        
    }
    
    private func registerCell(){
        topProductListCollectionView.registerCollectionCell(identifier: IAPImagePreviewCollectionCell.identifier)
    }
    
    
    
}


extension IAPSubscriptionViewController{
    
   private func startTimerForAnimateProductWithSwipeAnimation() {
        if #available(iOS 10.0, *) {
            var scrollWidth: CGFloat = 0.0
            if timerStore != nil {
                timerStore?.invalidate()
                timerStore = nil
            }
            timerStore = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self](timer) in
                let startingPoint = CGPoint(x: scrollWidth, y: 0)
                guard let weakSelf = self else {return}
                guard weakSelf.topProductListCollectionView != nil else {return}
                if (__CGPointEqualToPoint(startingPoint, weakSelf.topProductListCollectionView!.contentOffset)) {
                    if (scrollWidth < (weakSelf.topProductListCollectionView!.contentSize.width - weakSelf.topProductListCollectionView!.frame.size.width)) {
                        scrollWidth += ScreenSize.SCREEN_WIDTH
                        let offsetPoint = CGPoint(x: scrollWidth, y: 0)
                        weakSelf.topProductListCollectionView.setContentOffset(offsetPoint, animated: true)
                    } else {
                        scrollWidth = 0
                        let offsetPoint = CGPoint(x: scrollWidth, y: 0)
                        weakSelf.topProductListCollectionView.contentOffset = offsetPoint
                        scrollWidth = ScreenSize.SCREEN_WIDTH
                        let offsetPointAgain = CGPoint(x: scrollWidth, y: 0)
                        weakSelf.topProductListCollectionView.setContentOffset(offsetPointAgain, animated: true)
                    }
                } else {
                    scrollWidth = weakSelf.topProductListCollectionView.contentOffset.x
                }
            }
        }
    }
  
}
