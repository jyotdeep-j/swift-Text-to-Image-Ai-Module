//
//  CreateStyleViewController.swift
//  DreamAI
//
//  Created by iApp on 03/11/22.
//

import UIKit
import SDWebImage
import JHWaterFallFlowLayout
import StoreKit

enum CreateStyleType{
    case edit
    case new
}


protocol EditPromptDataDelegate: AnyObject {
    func reCreatePromptWithStabilityData(stabilityData: StabilityAiData, stabilityResponseModel: CutOutModel, aiStyle:AIStyle)
}

class CreateStyleViewController: BaseViewController {
    
    static let placeholderText = "So what are we creating? "
    weak var delegate: EditPromptDataDelegate?

    @IBOutlet weak var editPromptTopView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editPromptLabel: UILabel!
    
    //MARK: Claim Free Credit Outlets
    @IBOutlet weak var getCreditContainerView: UIView!
    @IBOutlet weak var getCreditButton: UIButton!
    
//    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var creditScoreContainerMainView: UIView!
    @IBOutlet weak var dailyCreditOfferView: UIView!
    
    @IBOutlet weak var dailyCreditCountDownLabel: UILabel!
    @IBOutlet weak var creditLimitCountContainerView: UIView!
    @IBOutlet weak var creditLimitCountButton: UIButton!
    
    
    @IBOutlet weak var imagePreviewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSliderHighlightLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseContainerView: UIView!
    
    //MARK: Expert Mode Switch and Random Button Container View
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var exportModeContainerView: UIView!
    @IBOutlet weak var showAdvancedLabel: UILabel!

    @IBOutlet weak var randomContainerView: UIView!
    @IBOutlet weak var randomButton: UIButton!
    
    @IBOutlet weak var randomInSimpleModeContainerView: UIView!
    
    @IBOutlet weak var randomInSimpleModeButton: UIButton!
    
    //MARK: Enter prompt Container outlets
    @IBOutlet weak var prompTextView: UITextView!
    @IBOutlet weak var clearPrompTextButton: UIButton!
    @IBOutlet weak var textCountButton: UIButton!

    
    @IBOutlet weak var expertModeContainerView: UIView!
    @IBOutlet weak var expertModelViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var promptTextViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var styleButton: UIButton!
    @IBOutlet weak var styleIconImageView: UIImageView!
    @IBOutlet weak var styleButtonContainerView: UIView!
    @IBOutlet weak var simpleModeEditingOptionsStackView: UIStackView!
    
    @IBOutlet weak var enterPromtTextBackView: UIView!

    @IBOutlet weak var preDefinedIdeasCollectionView: UICollectionView!{
        didSet{
            self.preDefinedIdeasCollectionView.collectionViewLayout = self.layout
        }
    }
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    
    @IBOutlet weak var enhanceButtonContainerView: UIView!
    @IBOutlet weak var enhanceButton: UIButton!
    
        
    @IBOutlet weak var tryTheseIdeaLabel: UILabel!
    
    
    @IBOutlet weak var styleCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mostPopularLabel: UILabel!
    @IBOutlet weak var mostPopularPromptCollectionView: UICollectionView!
    
    @IBOutlet weak var mostPopularPromptViewHeightConstraint: NSLayoutConstraint!

    
    lazy var numberOfImagesPopUpVC: NumberOfImagesPopUpViewController = {
        let popUpListVC = NumberOfImagesPopUpViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.delegate = self
        popUpListVC.currentNumberOfOutputImages =  NumberOfOutputImages(number: self.aiArtGeneratorVM.stabilityAIData.numberOfImages)
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()

    lazy var creditTimerCountDown = CountDownManager()
    private var artSavedPopup : Bool = false

    var exportModeCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.frame = CGRect(x: 0, y: 2, width: 48, height: 23)
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.isOn = false
        customSwitch.onTintColor = UIColor.appColor(.appBlueColor) ?? .blue//UIColor.orange
        customSwitch.offTintColor = UIColor.appColor(.appTextUltraLightGray) ?? .lightGray  //UIColor.darkGray
        customSwitch.cornerRadius = 11.5
        customSwitch.thumbCornerRadius = 11.5
        customSwitch.thumbTintColor = UIColor.clear
        customSwitch.animationDuration = 0.25
        customSwitch.addTarget(self, action: #selector(showAdvancedswitchAction(_:)), for: .valueChanged)
        customSwitch.thumbImage = UIImage(named: "Ellipse 20")
        return customSwitch
    }()
    
    
    lazy var createWithImagesView: CreateWithImagesView = {
        let createView: CreateWithImagesView = CreateWithImagesView.fromNib()
        createView.delagate = self
        createView.createStyleType = self.aiArtGeneratorVM.createStyleType
        createView.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT, width: self.view.bounds.width , height: CreateWithImagesView.heightOfPopUpView)
        createView.numberOfImages = aiArtGeneratorVM.stabilityAIData.numberOfImages
        return createView
    }()
   private var createViewAsInputAccessoryView: CreateWithImagesView?

    private var _expertModeCustomView:ExpertModeView?
    private var expertModeCustomView:ExpertModeView {
        if(_expertModeCustomView == nil) {
            let expertView: ExpertModeView = ExpertModeView.fromNib()
            expertView.modifierDelegate = self
            expertView.popUpViewDelegate = self
            expertView.currentAIStyle = self.aiArtGeneratorVM.currentAIStyle
            expertView.delegate = self
            expertView.stabilityAIData = aiArtGeneratorVM.stabilityAIData
            expertView.alpha = 0
            expertView.frame = CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ExpertModeView.exportModeHeight)
            self.expertModeContainerView.addSubview(expertView)
            _expertModeCustomView = expertView
        }
        return _expertModeCustomView!
    }

    private var toolTipTimer: Timer?
    private var toolTipTimeInSeconds: Double = 0.0
    
    lazy var toolTipCustomView: ToolTipCustomView = {
        let view: ToolTipCustomView = ToolTipCustomView.fromNib()
        view.frame = self.view.bounds
        return view
    }()
 
    public var aiArtGeneratorVM = AIArtGeneratorViewModel()
    
    private var isTextViewHavePlaceholder: Bool{
        get{
            return prompTextView.text == Self.placeholderText
        }
    }
    
    private lazy var layout: WaterFallFlowLayout = {
      let layout = WaterFallFlowLayout()
      layout.delegate = self
      layout.minimumLineSpacing = 10
      layout.minimumInteritemSpacing = 10
      layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      return layout
    }()
    
    //MARK: UIViewController Life Cycle
    override func loadView() {
        super.loadView()
    }
    
    func showTour() {
        let vc = WelcomeScreenVC(nibName: "WelcomeScreenVC", bundle: nil)
        vc.delagate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInputAccessoryView()
        if !UserDefaults.standard.bool(forKey: "AppTourCompleted"){
            showTour()
        }else{
            Helper.setBool(true, forKey: "is15CreditClaimed")
        }
        
        setupUIFont()
        setupUIDesign()
        registerCell()
        self.aiArtGeneratorVM.delegate = self
        setObservations()
    }
    
    private func setUpInputAccessoryView() {
        let createView: CreateWithImagesView = CreateWithImagesView.fromNib()
        createView.delagate = self
        createView.createStyleType = self.aiArtGeneratorVM.createStyleType
        createView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width , height: CreateWithImagesView.accessoryViewHeight)
        createView.numberOfImages = aiArtGeneratorVM.stabilityAIData.numberOfImages
        createView.setUpInputAccessoryView()
        self.createViewAsInputAccessoryView = createView
        self.prompTextView.returnKeyType = .done
        self.prompTextView.inputAccessoryView = createView
        self.prompTextView.inputAccessoryView?.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.currentTheme()
        if artSavedPopup{
            self.view.showToast(message: "Your art is here", frame: CGRect(x: self.view.frame.width-185, y: 45, width: 120, height: 50))
            artSavedPopup = false
        }
        if theme == .lightTheme {
            overrideUserInterfaceStyle = .light
        }else{
            overrideUserInterfaceStyle = .dark
        }
        if !StoreManager.shared.isPurchased{
            self.initialSetupOfCreditCountDown()
            self.creditLimitCountContainerView.isHidden = false
            self.highlightCreditScoreView()
        }else{
            dailyCreditOfferView.isHidden = true
            self.creditLimitCountContainerView.isHidden = true
            getCreditContainerView.isHidden = true
        }
        
    }
    
    private func highlightCreditScoreView(){
        if !StoreManager.shared.alreadyPurchased{
            let pendingCreditScore = Helper.sharedInstance.pendingCreditScore
            if pendingCreditScore > 2{
                creditLimitCountContainerView.backgroundColor = UIColor.appColor(.appTextYellow)
                creditLimitCountContainerView.layer.borderWidth = 0
                creditLimitCountContainerView.layer.borderColor = UIColor.clear.cgColor
                getCreditContainerView.isHidden = true
                setupCreditScoreView()
            }else{
                creditLimitCountContainerView.backgroundColor = UIColor(red: 82/255, green: 34/255, blue: 46/255, alpha: 1) //UIColor.appColor(.appRed)?.withAlphaComponent(0.5)
                creditLimitCountContainerView.layer.borderWidth = 1
                creditLimitCountContainerView.layer.borderColor = UIColor.appColor(.appRed)?.cgColor
                getCreditContainerView.isHidden = false
                setupCreditScoreView(textColor: UIColor.appColor(.appTextLightGray) ?? .darkText)
            }
        }
    }
    
    private func userJustStartItractWithApp(){
        toolTipTimer?.invalidate()
        toolTipTimer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.styleCollectionViewHeightConstraint.constant = self.preDefinedIdeasCollectionView.contentSize.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    private func setObservations() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseDone(_:)), name: Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    //MARK:- PURCHASE DONE
    @objc func purchaseDone(_ notification: Notification) {
        if let isPurchased = notification.object as? Bool {
            if isPurchased{
                self.creditLimitCountContainerView.isHidden = true
                self.dailyCreditOfferView.isHidden = true
                self.getCreditContainerView.isHidden = true
                creditTimerCountDown.stopTimer()
            }else{
                self.creditLimitCountContainerView.isHidden = false
                self.initialSetupOfCreditCountDown()
                self.highlightCreditScoreView()
            }
            setCreateStyleButton()
        }
    }
 
    
//MARK: UIAction button Methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func getCreditButtonAction(_ sender: UIButton) {
        Helper.sharedInstance.openIAPSubscription()
    }
    
    @IBAction func creditBalanceAction(_ sender: UIButton) {
        Helper.sharedInstance.openIAPSubscription()
    }
    
    @IBAction func clamDailyCreditAction(_ sender: UIButton) {
        aiArtGeneratorVM.addDailyLimitCredit()
        creditTimerCountDown.stopTimer()
        self.highlightCreditScoreView()
        self.showClaimFreeCreditPopUpView(with: 5)
    }
 
    
    @IBAction func promptHistoryAction(_ sender: UIButton) {
        userJustStartItractWithApp()
        let promptHistoryVC = PromptHistoryViewController.initiantiate(fromAppStoryboard: .Main)
        promptHistoryVC.delegate = self
        promptHistoryVC.modalPresentationStyle = .overCurrentContext
        self.present(promptHistoryVC, animated: false)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        userJustStartItractWithApp()
       // let settingVC = SettingViewController.initiantiate(fromAppStoryboard: .Main)
//        let projectVC = MyProjectsViewController.initiantiate(fromAppStoryboard: .Profile)
//        self.navigationController?.pushViewController(projectVC, animated: true)
        let paymentQueue = SKPaymentQueue.default()
        if #available(iOS 14.0, *) {
            DispatchQueue.main.async {
                paymentQueue.presentCodeRedemptionSheet()
            }
        }
    }
    
    @objc func showAdvancedswitchAction(_ sender: CustomSwitch) {
        userJustStartItractWithApp()
        aiArtGeneratorVM.isShowAdvancedOption = sender.isOn
        aiArtGeneratorVM.stabilityAIData.isExpertModeOn = sender.isOn
        debugPrint("aiArtGeneratorVM.isShowAdvancedOption ",aiArtGeneratorVM.isShowAdvancedOption)
        if !aiArtGeneratorVM.isShowAdvancedOption{
            self.aiArtGeneratorVM.stabilityAIData = aiArtGeneratorVM.resetStabilityData
            _expertModeCustomView?.removeFromSuperview()
            _expertModeCustomView = nil
        }else{
            self.expertModeCustomView.currentPromptText = self.aiArtGeneratorVM.currentPrompt
            self.expertModeCustomView.shouldHide = !aiArtGeneratorVM.isShowAdvancedOption
        }
      
        // Manage Expert Mode and Simple Mode UI
        let titleFont = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance

        if aiArtGeneratorVM.isShowAdvancedOption{
            let showAdvancedAttString = "Expert mode".attributedTo(font: titleFont, spacing: 0, color: .white)
            showAdvancedLabel.attributedText = showAdvancedAttString
            randomContainerView.isHidden = false
        }else{
            let showAdvancedAttString = "Turn on for more options".attributedTo(font: titleFont, spacing: 0, color: .white)
            showAdvancedLabel.attributedText = showAdvancedAttString
            randomContainerView.isHidden = true
        }
        
        expertModelViewHeightConstraint.constant = aiArtGeneratorVM.isShowAdvancedOption ? ExpertModeView.exportModeHeight : 14
       
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func showEnhanceViewAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let addModifiersVC = ModifiersListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        addModifiersVC.delegate = self
          addModifiersVC.modalPresentationStyle = .overCurrentContext
        let defaultPrompt = self.aiArtGeneratorVM.currentPrompt
        if defaultPrompt != "", defaultPrompt.count > 0{
            addModifiersVC.modifiersArray.append(defaultPrompt)
        }
        self.navigationController?.present(addModifiersVC, animated: true)
    }
    
    @IBAction func showStyleAction(_ sender: UIButton) {
        userJustStartItractWithApp()
        
        let promptStyleVC = PromptStyleListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        promptStyleVC.currentAIStyle = self.aiArtGeneratorVM.currentAIStyle
        promptStyleVC.delegate = self
        promptStyleVC.modalPresentationStyle = .fullScreen
        self.present(promptStyleVC, animated: true)
    }
    
    @IBAction func randomPromtAction(_ sender: UIButton) {
        userJustStartItractWithApp()
        self.view.endEditing(true)

        if let randomText = AIArtDataModel.randomArtKeyword.randomElement(){
            didSelectPromptHistory(prompt: randomText)
        }
    }
    
    @IBAction func clearRromtTextAction(_ sender: UIButton) {
        userJustStartItractWithApp()
        setUpTextViewPlaceholder()
        prompTextView.resignFirstResponder()
        setCreateStyleButton()
        aiArtGeneratorVM.currentSelectedMostPopularPrompt = nil
        mostPopularPromptCollectionView.reloadData()
        
        self.styleButtonContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.styleButtonContainerView.bounds.height/2)
        self.styleButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.styleButtonContainerView.bounds.height/2)
        self.styleButtonContainerView.backgroundColor = .clear
    }
    
    private func openWhyAdsPopUpFirstTime(){
        let reviewPopUpVC  = CustomReviewPopUpViewController.initiantiate(fromAppStoryboard: .Main)
        reviewPopUpVC.modalPresentationStyle = .overCurrentContext
        reviewPopUpVC.whyAdsDelegate = self
        reviewPopUpVC.shouldShowReviewPopUpView = false
        self.present(reviewPopUpVC, animated: true)
    }
    
    @IBAction func createStyleAction(_ sender: UIButton) {
        // Hit API for AI text
        // New task start from here(Start image module)
        
        if Helper.sharedInstance.pendingCreditScore <= 0 && !StoreManager.shared.isPurchased{
            Helper.sharedInstance.openIAPSubscription()
            return
        }
        CustomLoader.sharedInstance.show()
        self.aiArtGeneratorVM.createTextToImageAICutProWithImage()
        LocalDataManager.shared.addPromptInHistory(prompt: self.aiArtGeneratorVM.currentPrompt)
    }

}



extension CreateStyleViewController{
//MARK: Other Helper methods
   
    private func setupPromptAndUpdateHeight(prompt: String){

        prompTextView.removeIcon()
        let fontSize13 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let promtTextViewAttString = prompt.attributedTo(font: fontSize13, spacing: 0.60,lineSpacing: -8, color: UIColor.appColor(.appTextPlaceholder))
        prompTextView.attributedText = promtTextViewAttString
        
        var height = promtTextViewAttString.heightWithConstrainedWidth(width: prompTextView.bounds.width)
        height = (height < 50 ? 50 : height)
        height = (height > 120 ? 120 : height)
        
        if promptTextViewHeightConstraint.constant != height{
            let topSpacing = 80 - (height - 50)
            topViewTopConstraint.constant = topSpacing < 10 ? 10 : topSpacing//80 - (height - 50)//90
            promptTextViewHeightConstraint.constant = height //50
            UIView.animate(withDuration: 0.5, delay: 0.0,options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            }
        }
        if aiArtGeneratorVM.isShowAdvancedOption{
            self.expertModeCustomView.currentPromptText = prompTextView.text
        }
        setCreateStyleButton()
    }
    
    private func setCreateStyleButton(){
        if !prompTextView.text.isEmpty, !isTextViewHavePlaceholder{
            prompTextView.removeIcon()
            clearPrompTextButton.isHidden = false
            self.view.addSubview(self.createWithImagesView)
            self.createWithImagesView.show()
            createViewAsInputAccessoryView?.createAccessoryButton.isEnabled = true
            createViewAsInputAccessoryView?.createAccessoryButton.backgroundColor = UIColor.clear

        }else{
            aiArtGeneratorVM.promtText = ""
            aiArtGeneratorVM.currentAIStyle = .none
            clearPrompTextButton.isHidden = true
            self.createWithImagesView.hide()
            createViewAsInputAccessoryView?.createAccessoryButton.isEnabled = false
            createViewAsInputAccessoryView?.createAccessoryButton.backgroundColor = UIColor.appColor(.appDarkGray)
//            prompTextView.inputAccessoryView = nil
            
        }
        aiArtGeneratorVM.promtText = self.isTextViewHavePlaceholder ? "" : prompTextView.text
        
        let promptLenght = aiArtGeneratorVM.countOfTotalNumberOfCharacters
        let fontSize13 = Font(.installed(.PadaukRegular), size: .standard(.size13)).instance
        let clearPromtAttString = promptLenght.attributedTo(font: fontSize13, spacing: 0, color: UIColor.appColor(.appTextPlaceholder))
        textCountButton.setAttributedTitle(clearPromtAttString, for: .normal)
    }
   
}

//MARK: Prompt History, Modifier, PopUpView Deleagte, Export Mode Delegate methods Here
extension CreateStyleViewController: PromptHistoryDelegate, ModifierListDelegate, PopUpDataDelegate, ExpertModeViewDelegate,CustomAspectRatioDelegate{
    
    func didApplyRandomPrompt() {
        self.randomPromtAction(self.randomButton)
    }
    
    func didSelectCustomAspectSize(aspectSize: AIArtDataModel.AspectRatio) {
        aiArtGeneratorVM.stabilityAIData.width = Int(aspectSize.aspectSize.width)
        aiArtGeneratorVM.stabilityAIData.height = Int(aspectSize.aspectSize.height)
        aiArtGeneratorVM.stabilityAIData.aspectRatioSize = aspectSize
    }
    
    func popUpListControllerControllerDidDismiss() {
        self.view.removeBackgroundTintView()
    }
    
    func didEnterSeedValue(seed: Int64) {
        debugPrint(#function, "seedValue ",seed)
        aiArtGeneratorVM.stabilityAIData.seed = seed
    }
    
    func didSelectAspectSize(aspectSize: AIArtDataModel.AspectRatio) {
        debugPrint(#function, "aspect size", aspectSize)
        
        switch aspectSize {
        case .custom(_):
            let customAspectRatioView: CustomAspectRatioView = CustomAspectRatioView.fromNib()
            customAspectRatioView.frame = self.view.bounds
            customAspectRatioView.delegate = self
            let lastSize = CGSize(width: aiArtGeneratorVM.stabilityAIData.width, height: aiArtGeneratorVM.stabilityAIData.height)
            customAspectRatioView.showView()
            customAspectRatioView.lastAspectSize = lastSize
            self.view.addSubview(customAspectRatioView)
            break
        default:
            aiArtGeneratorVM.stabilityAIData.width = Int(aspectSize.aspectSize.width)
            aiArtGeneratorVM.stabilityAIData.height = Int(aspectSize.aspectSize.height)
            aiArtGeneratorVM.stabilityAIData.aspectRatioSize = aspectSize
        }
    }
    
    func didChangeSteps(type: PopUpListType, steps: Int, event: UITouch.Phase) {
        debugPrint(#function, "Mode type", type, "value ",steps)
        switch type {
        case .steps:
            aiArtGeneratorVM.stabilityAIData.steps = steps
            break
        case .cfgScale:
            aiArtGeneratorVM.stabilityAIData.cfgScale = steps
            break
        default: break
        }
    }
    
    func didSelectInputImage(inputImage: UIImage?) {
        self.aiArtGeneratorVM.stabilityAIData.inputImage = inputImage
    }
    
    func didSelectStableEngine(_ stableEngine: AIArtDataModel.AIStabileEngine) {
        self.aiArtGeneratorVM.stabilityAIData.inferenceEngineModel = stableEngine
    }
    
    func didSelectSamplerEngine(_ samplerEngine: AIArtDataModel.SamplerEngine) {
        debugPrint(#function, "samplerEngine ",samplerEngine)
        self.aiArtGeneratorVM.stabilityAIData.samplingEngine = samplerEngine
    }
    
    func didApplyAiStyleInPrompt(promptStyle: AIStyle) {
        self.aiArtGeneratorVM.currentAIStyle = promptStyle
        expertModeCustomView.currentAIStyle = promptStyle
        if promptStyle == .none{
            self.styleButtonContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.styleButtonContainerView.bounds.height/2)
            self.styleButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.styleButtonContainerView.bounds.height/2)
            self.styleButtonContainerView.backgroundColor = .clear
        }else{
            styleButtonContainerView.border(width: 1, color: .appBlueColor).corner(cornerRadius: styleButtonContainerView.bounds.height/2)
            styleButtonContainerView.backgroundColor = UIColor.appColor(.appBlueColor)?.withAlphaComponent(0.5)
        }
        self.mostPopularPromptCollectionView.reloadData()
        if let index = aiArtGeneratorVM.indexOfCurrentStyle{
            let indexPath = IndexPath(item: index, section: 0)
            self.mostPopularPromptCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        if aiArtGeneratorVM.isShowAdvancedOption {
            //Append text in text view
            if aiArtGeneratorVM.currentAIStyle != .none{
                if isTextViewHavePlaceholder{
                    prompTextView.text = ""
                    aiArtGeneratorVM.promtText = ""
                }
                let truncatedText = aiArtGeneratorVM.setPromptTextUptoLimit()
                self.didSelectIdeaOfTry(prompt: truncatedText, image: UIImage())
                let stringLength:Int = self.prompTextView.text.count
                self.prompTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
                self.setupPromptAndUpdateHeight(prompt: truncatedText)

            }
        }
    }
    
    func didApplySelectedModifier(prompt: String) {
        self.setupPromptAndUpdateHeight(prompt: prompt)
    }
    
    func didSelectPromptHistory(prompt: String) {
        self.setupPromptAndUpdateHeight(prompt: prompt)
    }
}

//MARK: AIArt Generator Delegate, Welcome Screen Delegates
extension CreateStyleViewController: AIArtGeneratorDelegate, WhyAdsInTheAppDelegate, WelcomeScreenDelagate{
    
    func showClaimFreeCreditPopUpView(with creditCount: Int){
        let claimCreditAfter24HourPopUpView: ClaimFreeCreditPupUpView = ClaimFreeCreditPupUpView.fromNib()
        claimCreditAfter24HourPopUpView.frame = self.view.bounds
        claimCreditAfter24HourPopUpView.layoutIfNeeded()
        self.view.addSubview(claimCreditAfter24HourPopUpView)
        claimCreditAfter24HourPopUpView.showView(withCreditNumber: creditCount)
    }
    
    func welcomeScreenWillDismiss() {
        //        toolTipTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        Helper.dispatchMainAfter(time: .now() + 0.5) {
            let is15CreditClaimed = Helper.bool(forKey: "is15CreditClaimed")
            if  !is15CreditClaimed{
                // claim 15 credit
                self.showClaimFreeCreditPopUpView(with: 15)
                self.aiArtGeneratorVM.addDailyLimitCredit(creditCount: 15)
                Helper.setBool(true, forKey: "is15CreditClaimed")
                
                let fontSize15 = Font(.installed(.PadaukBold), size: .standard(.h2)).instance
                let score = self.aiArtGeneratorVM.totalCreditScore
                let attr = "Credits \(score)".attributedTo(font: fontSize15, spacing: 0.1, color: .black,alignment: .center)
                self.creditLimitCountButton.setAttributedTitle(attr, for: .normal)
                
                self.creditLimitCountContainerView.backgroundColor = UIColor.appColor(.appTextYellow)
                self.creditLimitCountContainerView.layer.borderWidth = 0
                self.creditLimitCountContainerView.layer.borderColor = UIColor.clear.cgColor
                self.getCreditContainerView.isHidden = true
            }
        }

    }
    
    func didTapOnRemoveAdButton() {
        Helper.sharedInstance.openIAPSubscription()
    }
    
    func didTapOnWatchAdButton() {}
    
    func didTapCancelButton() {}
    
    //MARK: Setup Art Genseration Delegate Merthods
    func setupCompleteAds() {
        GoogleAdMobHandler.shared.adDidDismissFullScreen = { [weak self] (isAddRewarded, isRecreate) in
            CustomLoader.sharedInstance.show()
            Helper.dispatchMain {
                self?.aiArtGeneratorVM.createTextToImageAICutPro()
            }
        }
    }
    
    func didGetStabilityResult(result: CutOutModel) {
        CustomLoader.sharedInstance.hide()
        Helper.sharedInstance.claimedCreditScore()
//        self.highlightCreditScoreView()
        Helper.dispatchMain {
            Helper.sharedInstance.imageCreationCountPerAppSession += 1
            Helper.sharedInstance.updateFreeTrailCountForCreateText2Image()
            if self.aiArtGeneratorVM.createStyleType == .edit{
                self.aiArtGeneratorVM.stabilityAIData.prompt = self.aiArtGeneratorVM.promtText
                self.delegate?.reCreatePromptWithStabilityData(stabilityData: self.aiArtGeneratorVM.stabilityAIData, stabilityResponseModel: result,aiStyle: self.aiArtGeneratorVM.currentAIStyle)
                self.dismiss(animated: true)
            }else{
                let resultVC = SaveShareMediaViewController.initiantiate(fromAppStoryboard: .Main)
                let navController = UINavigationController(rootViewController: resultVC) //Add navigation controller
                resultVC.saveShareMediaVM.stabilityResponseModel = result
                resultVC.savedDelegate = self
                self.aiArtGeneratorVM.stabilityAIData.prompt = self.aiArtGeneratorVM.promtText
                resultVC.saveShareMediaVM.stabilityAIData = self.aiArtGeneratorVM.stabilityAIData
                resultVC.saveShareMediaVM.currentAIStyle = self.aiArtGeneratorVM.currentAIStyle
                resultVC.modalPresentationStyle = .fullScreen
                navController.modalPresentationStyle = .fullScreen
                navController.isNavigationBarHidden = true
                self.present(navController, animated: true)
            }
        }
    }
    
    func didGetResultStabilityMemes(with url: String) {
        CustomLoader.sharedInstance.hide()
    }
    
    func didDoneText2ImageResult(_ model: Text2ImageResultDataModel?, _ message: String?) {
        CustomLoader.sharedInstance.hide()
        Helper.dispatchMain {
            if let message = message {
                UIAlertController.alert(title: "Error", message: message, viewController: self)
            }
        }
    }
}

//MARK: Create With Image Delegate
extension CreateStyleViewController: CreateWithImageDelegate, NumberOfImageCountDelegate{
    func didDismissPopUpView() {
        self.view.removeBackgroundTintView()
    }
    
    func willCreateImageAction(_ sender: UIButton) {
        debugPrint("function ",#function)
        self.prompTextView.resignFirstResponder()
        self.createStyleAction(sender)
    }
  
    func didOptionImageCountSelectionViewPopUp(_ sender: UIButton) {
        debugPrint("function ",#function)
        if let topVC = UIApplication.topViewController(){
            if let superView = sender.superview{
                topVC.view.backgroudTintView(superView,cornerRadius: superView.layer.cornerRadius)
            }
            numberOfImagesPopUpVC.popoverPresentationController?.permittedArrowDirections = .down
            numberOfImagesPopUpVC.popoverPresentationController?.sourceView = sender
            numberOfImagesPopUpVC.popoverPresentationController?.delegate = self
            topVC.present(numberOfImagesPopUpVC, animated: true)
        }
    }
    
    func didSelectNumberOfImagesForOutput(numberOfImage: NumberOfOutputImages) {
        let numberOfImage = Int(numberOfImage.detail().title) ?? 1
        debugPrint(#function, "numberOfImage ",numberOfImage)
        createWithImagesView.numberOfImages = numberOfImage
        self.createViewAsInputAccessoryView?.numberOfImages = numberOfImage
        self.aiArtGeneratorVM.stabilityAIData.numberOfImages = numberOfImage
    }
}


extension CreateStyleViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        debugPrint(#function)
        self.view.removeBackgroundTintView()
        
    }
}


extension CreateStyleViewController: UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        userJustStartItractWithApp()
        if self.isTextViewHavePlaceholder {
            textView.text = nil
            prompTextView.textColor = UIColor.appColor(.txtViewTitleColor)
            prompTextView.removeIcon()
            createViewAsInputAccessoryView?.createAccessoryButton.isEnabled = false
            createViewAsInputAccessoryView?.createAccessoryButton.backgroundColor = UIColor.appColor(.appDarkGray)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setupPromptAndUpdateHeight(prompt: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.setPlaceholder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        debugPrint("total number of characters ",textView.text.count + 1)
        if self.prompTextView.bounds.height > 100 && range.location > 100{
//            let stringLength:Int = self.prompTextView.text.count
            self.prompTextView.scrollRangeToVisible(NSMakeRange(range.location, 0))
        }
        
        let currentText = textView.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // make sure the result is under 16 characters
        return updatedText.count <= AIArtGeneratorViewModel.totalNumberOfCharactersAllowedInPrompt
    }
}

//MARK: Collection View Delegate and Data Sources
extension CreateStyleViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        mostPopularPromptCollectionView.registerCollectionCell(identifier: AIStyleCollectionCell.identifier)
        preDefinedIdeasCollectionView.registerCollectionCell(identifier: SuggestedStyleCollectionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mostPopularPromptCollectionView{//styleCollectionView{
            return  aiArtGeneratorVM.numberOfStyles
        }
        return aiArtGeneratorVM.numberOfPromptIdeas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mostPopularPromptCollectionView{//styleCollectionView{
            let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: AIStyleCollectionCell.identifier, for: indexPath) as! AIStyleCollectionCell
            let style =  aiArtGeneratorVM.styleAtIndex(index: indexPath.item)
            cellA.isStyleSelected = aiArtGeneratorVM.isStyleSelected(atIndex: indexPath.item)
            cellA.configureCell(with: style)
            return cellA
        } else{
            let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedStyleCollectionCell.identifier, for: indexPath) as! SuggestedStyleCollectionCell
         
            if let promptIdeaData = aiArtGeneratorVM.promptIdeaData(atIndex: indexPath.item){
                if let imageName = promptIdeaData.resultImages.first?.imageName{
                    cellA.configureCellForPreview(with: imageName)
                }
            }
            return cellA
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userJustStartItractWithApp()
        if collectionView == mostPopularPromptCollectionView{ //styleCollectionView {
            let style =  aiArtGeneratorVM.styleAtIndex(index: indexPath.item)
                aiArtGeneratorVM.didSelectStyleAtIndex(index: indexPath.item)
                self.mostPopularPromptCollectionView.reloadData()
                self.mostPopularPromptCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
            if style == .none{
                self.styleButtonContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.styleButtonContainerView.bounds.height/2)
                self.styleButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.styleButtonContainerView.bounds.height/2)
                self.styleButtonContainerView.backgroundColor = .clear
            }else{
                styleButtonContainerView.border(width: 1, color: .appBlueColor).corner(cornerRadius: styleButtonContainerView.bounds.height/2)
                styleButtonContainerView.backgroundColor = UIColor.appColor(.appBlueColor)?.withAlphaComponent(0.5)
            }
            
        }else{

            let tryTheseIdeaVC = TryTheseIdeasViewController.initiantiate(fromAppStoryboard: .ExportMode)
            if let promptIdeaData = aiArtGeneratorVM.promptIdeaData(atIndex: indexPath.item){
                tryTheseIdeaVC.promptStabilityData = promptIdeaData
            }
            tryTheseIdeaVC.delegate = self
            tryTheseIdeaVC.modalPresentationStyle = .overCurrentContext
            self.present(tryTheseIdeaVC, animated: false)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mostPopularPromptCollectionView{ //styleCollectionView{
           /* let collectionWidth = collectionView.bounds.width  - 50
            return CGSize(width: collectionWidth / 4, height: collectionView.frame.size.height - 15)*/
            let collectionWidth = collectionView.bounds.width  - 50
            let cellSize = CGSize(width: collectionWidth / 4, height: collectionWidth / 4)
            debugPrint("cellSize ",cellSize)
            return cellSize
        }else{
            switch self.aiArtGeneratorVM.currentListPreview {
            case .list:
                return CGSize.init(width: collectionView.frame.size.width, height:collectionView.frame.size.width)
            case .grid:
                return CGSize.init(width: (collectionView.frame.size.width/2)-15, height:(collectionView.frame.size.width/2)-15)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mostPopularPromptCollectionView{ //styleCollectionView{
            return 15
        }
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mostPopularPromptCollectionView{ //styleCollectionView{
            return 15
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == mostPopularPromptCollectionView{ //styleCollectionView{
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension CreateStyleViewController: WaterFallFlowLayoutDelegate{
    func waterFallFlowLayout(_ waterFallFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
      guard let promptIdeaData = aiArtGeneratorVM.promptIdeaData(atIndex: indexPath.item) else {
        return 0.0
      }

      let imageWidth = waterFallFlowLayout.itemWidth
      let imageHeight = CGFloat(promptIdeaData.height) * imageWidth / CGFloat(promptIdeaData.width)

      print("\(indexPath.item) image height: \(imageHeight)")

      return imageHeight
    }

    func columnOfWaterFallFlow(in collectionView: UICollectionView) -> Int {
      return 2
    }
}

extension CreateStyleViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.userJustStartItractWithApp()
    }
    
   
}

extension CreateStyleViewController: SuggestedStyleDelegate {
    
    func didSelectIdeaOfTry(prompt: String, image: UIImage) {
        setupPromptAndUpdateHeight(prompt: prompt)
 
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.contentScrollView.contentOffset = .zero
        } completion: { isComplete in
            
        }
    }
  
}

extension CreateStyleViewController {
    
   private func setupUIDesign() {
       
       exportModeContainerView.addSubview(exportModeCustomSwitch)
       self.randomContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.randomContainerView.bounds.height/2)
       self.randomContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.randomContainerView.bounds.height/2)
       
       self.randomInSimpleModeContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.randomInSimpleModeContainerView.bounds.height/2)
       self.randomInSimpleModeContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.randomInSimpleModeContainerView.bounds.height/2)
       
       self.styleButtonContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.styleButtonContainerView.bounds.height/2)
       self.styleButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.styleButtonContainerView.bounds.height/2)
       
       self.enhanceButtonContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: self.enhanceButtonContainerView.bounds.height/2)
       self.enhanceButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: self.enhanceButtonContainerView.bounds.height/2)
       
       enterPromtTextBackView.layer.cornerRadius =  enterPromtTextBackView.bounds.height/2//2.5
       enterPromtTextBackView.layer.masksToBounds = true
       enterPromtTextBackView.layer.borderColor = UIColor.appColor(.appGray)?.cgColor
       enterPromtTextBackView.layer.borderWidth = 0.7

       getCreditContainerView.layer.cornerRadius =  getCreditContainerView.bounds.height/2

       uiSetupForCreateNewStyleAndEdit()
       setUpPreFieldStabilityDataInEditMode()

   }
    
    //MARK: Pre field preview data in Edit Mode
    private func setUpPreFieldStabilityDataInEditMode(){
        switch self.aiArtGeneratorVM.createStyleType{
        case .edit:
            self.exportModeCustomSwitch.isOn = aiArtGeneratorVM.stabilityAIData.isExpertModeOn
            if aiArtGeneratorVM.stabilityAIData.isExpertModeOn{
                showAdvancedswitchAction(self.exportModeCustomSwitch)
            }
            if let prompt = self.aiArtGeneratorVM.stabilityAIData.prompt{
                self.setupPromptAndUpdateHeight(prompt: prompt)
                self.prompTextView.becomeFirstResponder()
            }
            self.createWithImagesView.numberOfImages = self.aiArtGeneratorVM.stabilityAIData.numberOfImages
            self.createViewAsInputAccessoryView?.numberOfImages = self.aiArtGeneratorVM.stabilityAIData.numberOfImages
            self.editPromptTopView.isHidden = false
            
            let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
            let titleTextAttri = editPromptLabel.text?.attributedTo(font: fontSize18, spacing: 0, color: .white,alignment: .center)
            editPromptLabel.attributedText = titleTextAttri
            simpleModeEditingOptionsStackView.isHidden = true
            break
        case .new: break
            
        }
    }
    
    private func uiSetupForCreateNewStyleAndEdit(){
            /// Only Prompt Text Box and Expert mode should be shown in Edit Mode
        switch self.aiArtGeneratorVM.createStyleType{
        case .edit:
            self.creditScoreContainerMainView.isHidden = true
            self.mostPopularPromptViewHeightConstraint.constant = 0
            self.styleCollectionViewHeightConstraint.constant = 0
            self.tryTheseIdeaLabel.isHidden = true
            self.backButton.isHidden = false
            self.dailyCreditOfferView.isHidden = true
            break
        case .new:
            self.backButton.isHidden = true
            preDefinedIdeasCollectionView.delegate = self
            preDefinedIdeasCollectionView.dataSource = self
            break
        }
    }
   
    private func setPlaceholder() {
        let fontSize15 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let firstString = Self.placeholderText
        let titleAttribute = firstString.attributedTo(font: fontSize15, spacing: 0.75,lineSpacing: -8, color: UIColor.appColor(.appTextPlaceholder),alignment: .left)
        
        prompTextView.attributedText = titleAttribute
        prompTextView.setIcon(UIImage(named: "smile")!)

    }
    
    private func setUpTextViewPlaceholder(){
        let fontSize15 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let firstString = Self.placeholderText
        let titleAttribute = firstString.attributedTo(font: fontSize15, spacing: 0.75,lineSpacing: -8, color: UIColor.appColor(.appTextPlaceholder),alignment: .left)
        prompTextView.attributedText = titleAttribute
        prompTextView.setIcon(UIImage(named: "smile")!)
        topViewTopConstraint.constant = 80
        promptTextViewHeightConstraint.constant = 50
        UIView.animate(withDuration: 0.5, delay: 0.0,options: [.curveEaseInOut]) {
            self.view.layoutIfNeeded()
        }
    }
    
 
    private func setupUIFont() {
        self.setPlaceholder()

        let fontSize15 = Font(.installed(.appBold), size: .standard(.size15)).instance
        let fontSize16 = Font(.installed(.appBold), size: .standard(.h3)).instance

        let titleFont = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let fontSize13 = Font(.installed(.PadaukRegular), size: .standard(.size13)).instance
        
        let showAdvancedAttString = showAdvancedLabel.text?.attributedTo(font: titleFont, spacing: 0, color: .white)
        showAdvancedLabel.attributedText = showAdvancedAttString
       
        let attString = randomButton.currentTitle?.attributedTo(font: titleFont, spacing: 0, color: .white)//.underline(1)
        randomButton.setAttributedTitle(attString, for: .normal)
        randomInSimpleModeButton.setAttributedTitle(attString, for: .normal)
                
        let enhanceString = enhanceButton.currentTitle?.attributedTo(font: titleFont, spacing: 0, color: .white)//.underline(1)
        enhanceButton.setAttributedTitle(enhanceString, for: .normal)
        
        let clearPromtAttString = textCountButton.currentTitle?.attributedTo(font: fontSize13, spacing: 0, color: UIColor.appColor(.appTextPlaceholder))
        textCountButton.setAttributedTitle(clearPromtAttString, for: .normal)
    
        let mostPopularAttr = mostPopularLabel.text?.attributedTo(font: fontSize15, spacing: 0.75, color: UIColor.appColor(.appTextTitleColor))
        self.mostPopularLabel.attributedText = mostPopularAttr
     
        let regular25 = Font(.installed(.PadaukRegular), size: .custom(24)).instance
        let tryTheseIdeaTitle = tryTheseIdeaLabel.text?.attributedTo(font: regular25, spacing: 0, color: UIColor.white)
        tryTheseIdeaLabel.attributedText = tryTheseIdeaTitle
        
        // Button titles
        let styleButtonStr = styleButton.currentTitle?.attributedTo(font: titleFont, spacing: 0, color: .white)//.underline(1)
        styleButton.setAttributedTitle(styleButtonStr, for: .normal)
        
        let myRiadBold = Font(.installed(.myRiadBold), size: .standard(.h3)).instance
        let getCreditAtt = getCreditButton.currentTitle?.attributedTo(font: myRiadBold, spacing: 0, color: UIColor.appColor(.appRed))//.underline(1)
        getCreditButton.setAttributedTitle(getCreditAtt, for: .normal)
    }
    
    //MARK: Manage Credit Score
    
    private func setupCreditScoreView(textColor: UIColor = .black){
        let fontSize15 = Font(.installed(.PadaukBold), size: .standard(.h2)).instance
        let score = aiArtGeneratorVM.totalCreditScore
        let attr = "Credits \(score)".attributedTo(font: fontSize15, spacing: 0.1, color: textColor,alignment: .center)
        creditLimitCountButton.setAttributedTitle(attr, for: .normal)
        
        creditLimitCountContainerView.layer.cornerRadius = creditLimitCountContainerView.bounds.height/2
        setUpCreditBannerWithCountDown()
    }
    
    private func setUpCreditBannerWithCountDown() {
        let is15CreditClaimed = Helper.bool(forKey: "is15CreditClaimed")
        if  is15CreditClaimed{
            dailyCreditOfferView.isHidden = aiArtGeneratorVM.isDailyCreditLimitClaimed
            if !dailyCreditOfferView.isHidden{
                dailyCreditOfferView.animationBubbleEffect()
            }
        }else{
            dailyCreditOfferView.isHidden = true
        }
    }
}

extension CreateStyleViewController: SavedInMyProject{
    
    func savedInProject(isSaved: Bool) {
        self.artSavedPopup = isSaved
    
    }
    
    private func initialSetupOfCreditCountDown(){
        creditTimerCountDown.startTimer { currentTime in
           // debugPrint(" Credit timer start ", currentTime)
        }
    }
}


