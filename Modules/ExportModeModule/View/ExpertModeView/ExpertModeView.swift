//
//  ExpertModeView.swift
//  DreamAI
//
//  Created by iApp on 20/12/22.
//

import UIKit
protocol ExpertModeViewDelegate: AnyObject{
    func didSelectInputImage(inputImage: UIImage?)
    func didSelectAspectSize(aspectSize: AIArtDataModel.AspectRatio)
    func didEnterSeedValue(seed: Int64)
}

class ExpertModeView: UIView {
    
    weak var delegate: ExpertModeViewDelegate?
    weak var modifierDelegate: ModifierListDelegate?
    weak var popUpViewDelegate: PopUpDataDelegate?
    static let exportModeHeight: CGFloat = 690//768
    
    //MARK: Negative Prompt
    @IBOutlet weak var negativePromptContainerView: UIView!
    @IBOutlet weak var clearNegativePromptButton: UIButton!
    @IBOutlet weak var negativePromptTextView: UITextView!
    @IBOutlet weak var negativePromptLabel: UILabel!
    
    //MARK: Prompt Views
    
    @IBOutlet weak var promptStyleContainerView: UIView!
    @IBOutlet weak var promptStyleButton: UIButton!
    @IBOutlet weak var listOfPromptContainerView: UIView!
    @IBOutlet weak var listOfPromptButton: UIButton!
    @IBOutlet weak var randomPromptContainerView: UIView!
    @IBOutlet weak var randomPromptButton: UIButton!
    
    //MARK: Stable Engine list properties
    @IBOutlet weak var stableEngineContainerView: UIView!
    @IBOutlet weak var stableEngineButton: UIButton!
    
    //MARK: Input Image Properties

    @IBOutlet weak var imputImageContainerView: UIView!
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var inputImageLabel: UILabel!
    
    //MARK: Steps and cfgScale Container View
    @IBOutlet weak var stepsContainerView: UIView!
    @IBOutlet weak var stepsButton: UIButton!
    @IBOutlet weak var cgfScaleContainerView: UIView!
    @IBOutlet weak var cgfScaleButton: UIButton!
    
    //MARK: Aspect Ratio Container View
    @IBOutlet weak var aspectRatioContainerView: UIView!
    
    @IBOutlet weak var ratioButton_1_1: UIButton!
    @IBOutlet weak var ratioButton_2_3: UIButton!
    @IBOutlet weak var ratioButton_3_2: UIButton!
    @IBOutlet weak var ratioCustomButton: UIButton!
    @IBOutlet var ratioButtonsCollection: [UIButton]!

    
    //MARK: Seed Container View
    @IBOutlet weak var seedContainerView: UIView!
    @IBOutlet weak var seedTitleLabel: UILabel!
    @IBOutlet weak var randomSeedLabel: UILabel!
    @IBOutlet weak var seedNumberTextField: UITextField!
    @IBOutlet weak var seedSwitchContainerView: UIView!
    
    
    //MARK: Smapler Container View
    @IBOutlet weak var samplerContainerView: UIView!
    @IBOutlet weak var samplerEngineListButtonView: UIView!
    @IBOutlet weak var samplerTitleLabel: UILabel!
    @IBOutlet weak var samplerEngineLabel: UILabel!
    @IBOutlet weak var samplingEngineButton: UIButton!
    @IBOutlet weak var clipGuidanceLabel: UILabel!
    
    
    //MARK: Priperties that need to functional
    @IBOutlet weak var clipGuidanceSwitchContainerView: UIView!
    @objc dynamic public var currentPromptText: String = ""

    public var stabilityAIData: StabilityAiData!{
        didSet{
            self.setupPreFieldValues()
        }
    }
    
    public var currentAIStyle: AIStyle = .none{
        didSet{
            self.highlightStyleButton()
        }
    }
    
    public var shouldHide: Bool = true {
        didSet{
            if !shouldHide{
                setValues(type: .steps, value: stabilityAIData.steps)
                setValues(type: .cfgScale, value: stabilityAIData.cfgScale)
            }
            let alpha: CGFloat = shouldHide ? 0 : 1
            UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut) {
                self.alpha = alpha
            }
        }
    }
    
    lazy var stableEngineListVC: PopUpListViewController = {
        let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.popUpDataVM.popUpListType = .engine
        popUpListVC.popUpDataVM.currentStabileEngine = stabilityAIData.inferenceEngineModel//.diffusion_v1_5
        popUpListVC.delegate = self
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()
    
    lazy var stepsPopUpVC: PopUpListViewController = {
        let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.popUpDataVM.popUpListType = .steps
        popUpListVC.popUpDataVM.stepsValue = self.stabilityAIData.steps
        popUpListVC.delegate = self
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()
    
    lazy var cfgScalePopUpVC: PopUpListViewController = {
        let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.popUpDataVM.popUpListType = .cfgScale
        popUpListVC.enableStep = true
        popUpListVC.popUpDataVM.cfgScaleValue = self.stabilityAIData.cfgScale
        popUpListVC.delegate = self
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()
    
    lazy var samplerEngineListVC: PopUpListViewController = {
        let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.popUpDataVM.popUpListType = .sampler
        popUpListVC.popUpDataVM.currentSamplerEngine = self.stabilityAIData.samplingEngine
        popUpListVC.delegate = self
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()
    
    lazy var selectImagePopUpVC: PopUpListViewController = {
        let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
        popUpListVC.popUpDataVM.popUpListType = .imageSelection
        popUpListVC.imageDelegate = self
        popUpListVC.delegate = self
        popUpListVC.modalPresentationStyle = .popover
        return popUpListVC
    }()
    
    var seedCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.frame = CGRect(x: 0, y: 0, width: 48, height: 23)
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.isOn = true
        customSwitch.onTintColor = UIColor.appColor(.appBlueColor) ?? .blue//UIColor.orange
        customSwitch.offTintColor = UIColor.appColor(.appTextUltraLightGray) ?? .lightGray  //UIColor.darkGray
        customSwitch.cornerRadius = 11.5
        customSwitch.thumbCornerRadius = 11.5
        customSwitch.thumbTintColor = UIColor.clear
        customSwitch.animationDuration = 0.25
        customSwitch.addTarget(self, action: #selector(onSeedForLatentNoiseAction(_:)), for: .valueChanged)
        customSwitch.thumbImage = UIImage(named: "Ellipse 20")
        return customSwitch
    }()
    
    var sampleEngineCustomSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.frame = CGRect(x: 0, y: 0, width: 48, height: 23)
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.isOn = true
        customSwitch.onTintColor = UIColor.appColor(.appBlueColor) ?? .blue//UIColor.orange
        customSwitch.offTintColor = UIColor.appColor(.appTextUltraLightGray) ?? .lightGray  //UIColor.darkGray
        customSwitch.cornerRadius = 11.5
        customSwitch.thumbCornerRadius = 11.5
        customSwitch.thumbTintColor = UIColor.clear
        customSwitch.animationDuration = 0.25
        customSwitch.addTarget(self, action: #selector(enableSmaplerEngineAction(_:)), for: .valueChanged)
        customSwitch.thumbImage = UIImage(named: "Ellipse 20")
        return customSwitch
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUIDesign()
        self.setUpUIFont()
        self.addCustomSubviews()
        self.ratioButton_1_1.isSelected = true
        self.manageAspectRatioButton()
        samplingEngineButton.isEnabled = !sampleEngineCustomSwitch.isOn
        seedNumberTextField.isEnabled = !seedCustomSwitch.isOn

    }
    
    
    
    private func addCustomSubviews(){
        self.seedSwitchContainerView.addSubview(seedCustomSwitch)
        self.clipGuidanceSwitchContainerView.addSubview(sampleEngineCustomSwitch)
    }
    
    private func highlightStyleButton(){
        if currentAIStyle == .none{
            self.promptStyleContainerView.blurViewEffect(withAlpha: 0.5, cornerRadius: 15)
            self.promptStyleContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
            self.promptStyleContainerView.backgroundColor = .clear
        }else{
            promptStyleContainerView.border(width: 1, color: .appBlueColor).corner(cornerRadius: 15)
            promptStyleContainerView.backgroundColor = UIColor.appColor(.appBlueColor)?.withAlphaComponent(0.5)
        }
    }
    
    private func manageAspectRatioButton(){
        for rationButton in ratioButtonsCollection{
            var titleColor = UIColor.appColor(.appTextLightGray)
            if rationButton.isSelected{
                titleColor = UIColor.appColor(.appBlueColor)
            }
            let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
            let sizeButtonTitle = rationButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0, color: titleColor,alignment: .center)
            rationButton.setAttributedTitle(sizeButtonTitle, for: .normal)
        }
    }
    
    //MARK: Setup Previous Values in fields
    private func setupPreFieldValues() {
        guard let stabilityAIData = self.stabilityAIData else {return}
        
//        let fontSize14 = Font(.installed(.PadaukRegular), size: .standard(.h4)).instance
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
//        let fontSize17 = Font(.installed(.PadaukRegular), size: .custom(17)).instance

        let textColor = UIColor.appColor(.appTextLightGray)
        
//        let fontSize19 = Font(.installed(.PadaukRegular), size: .custom(19)).instance

        let stabilityTitle = stabilityAIData.inferenceEngineModel.engine().name

        let stablibityEngine = stabilityTitle.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .center)
        stableEngineButton.setAttributedTitle(stablibityEngine, for: .normal)
        
        let seedNumber = stabilityAIData.seed
        if seedNumber > 0{
            seedCustomSwitch.isOn = false
            self.onSeedForLatentNoiseAction(seedCustomSwitch)
        }
        let seedNumberAttr = "\(seedNumber)".attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        seedNumberTextField.attributedText = seedNumberAttr
     
        if stabilityAIData.samplingEngine != .Automatic{
            self.sampleEngineCustomSwitch.isOn = false
            self.enableSmaplerEngineAction(self.sampleEngineCustomSwitch)
        }
        let samplerTitle = stabilityAIData.samplingEngine.rawValue
        samplerEngineLabel.attributedText = samplerTitle.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        
        let aspectSize = stabilityAIData.aspectRatioSize
        
        var previousRatioButton = ratioButton_1_1
        switch aspectSize {
        case .square:
            previousRatioButton = ratioButton_1_1
        case .ratio2_3:
            previousRatioButton = ratioButton_2_3
        case .ratio3_2:
            previousRatioButton = ratioButton_3_2
        case .custom(_):
            previousRatioButton = ratioCustomButton
        }
        for rationButton in ratioButtonsCollection{
            if rationButton == previousRatioButton{
                rationButton.isSelected = true
            }else{
                rationButton.isSelected = false
            }
        }
        manageAspectRatioButton()
        
        if let image  = stabilityAIData.inputImage{
            self.inputImageView.image = image
            self.showHideImagePreviewContainer()
        }
       
    }
    
    
    @IBAction func promptStyleAction(_ sender: UIButton) {
        if let topVC = UIApplication.topViewController() {
            let promptStyleVC = PromptStyleListViewController.initiantiate(fromAppStoryboard: .ExportMode)
            promptStyleVC.currentAIStyle = self.currentAIStyle
            promptStyleVC.delegate = self.modifierDelegate
            promptStyleVC.modalPresentationStyle = .fullScreen
            topVC.present(promptStyleVC, animated: true)
        }
    }
    
    @IBAction func listOfPromptAction(_ sender: UIButton) {
        if let topVC = UIApplication.topViewController(){
            let addModifiersVC = ModifiersListViewController.initiantiate(fromAppStoryboard: .ExportMode)
            addModifiersVC.delegate = self.modifierDelegate
              addModifiersVC.modalPresentationStyle = .fullScreen
            let defaultPrompt = currentPromptText
            if defaultPrompt != "", defaultPrompt.count > 0{
                addModifiersVC.modifiersArray.append(defaultPrompt)
            }
            topVC.present(addModifiersVC, animated: true)
        }
    }
    @IBAction func randomPromptAction(_ sender: UIButton) {
        self.modifierDelegate?.didApplyRandomPrompt()
    }
    
    
    @IBAction func stableEngineAction(_ sender: UIButton) {
        if let topVC = UIApplication.topViewController(){
//            backgroudView(tintColor: sender, controller: topVC)
            topVC.view.backgroudTintView(self.stableEngineContainerView)
            self.stableEngineContainerView.backgroundColor = UIColor.appColor(.startImageBorderColor)
            stableEngineListVC.popoverPresentationController?.sourceView = sender
            stableEngineListVC.popoverPresentationController?.delegate = self
            topVC.present(stableEngineListVC, animated: true)
        }
        
        
        
       /* if let topVC = UIApplication.topViewController(){
            let popUpListVC = PopUpListViewController.initiantiate(fromAppStoryboard: .ExportMode)
            popUpListVC.popUpDataVM.popUpListType = .engine
            popUpListVC.popUpDataVM.currentStabileEngine = .inpainting_512_v2_0
            popUpListVC.modalPresentationStyle = .popover
            popUpListVC.popoverPresentationController?.sourceView = sender
            popUpListVC.popoverPresentationController?.delegate = self
            topVC.present(popUpListVC, animated: true, completion: nil)
        }*/
    }

    
    @IBAction func selectInputImageAction(_ sender: UIButton) {
        if self.inputImageView.image == nil{
            if let topVC = UIApplication.topViewController(){
                ImagePickerHandler.shared.showAttachmentActionSheet(vc: topVC)
                ImagePickerHandler.shared.imagePickedHandler = { [weak self](image) in
                    Helper.dispatchMain {
                        self?.inputImageView.image = image
                        self?.delegate?.didSelectInputImage(inputImage: image)
                        self?.showHideImagePreviewContainer()
                    }
                }
            }
        }else{
            if let topVC = UIApplication.topViewController(){
                topVC.view.backgroudTintView(self.imputImageContainerView)
//                self.stableEngineContainerView.backgroundColor = UIColor.appColor(.startImageBorderColor)
                selectImagePopUpVC.modalPresentationStyle = .popover
                selectImagePopUpVC.popoverPresentationController?.sourceView = sender
                selectImagePopUpVC.popoverPresentationController?.delegate = self
                topVC.present(selectImagePopUpVC, animated: true)
            }
        }
    }
    
    @IBAction func setpsButtonAction(_ sender: UIButton) {
        
        if let topVC = UIApplication.topViewController(){
            topVC.view.backgroudTintView(self.stepsContainerView)
            self.stepsContainerView.backgroundColor = UIColor.appColor(.startImageBorderColor)
            stepsPopUpVC.popoverPresentationController?.sourceView = sender
            stepsPopUpVC.popoverPresentationController?.delegate = self
            topVC.present(stepsPopUpVC, animated: true)
        }
    }
    
    @IBAction func cgfScaleAction(_ sender: UIButton) {
        if let topVC = UIApplication.topViewController(){
            topVC.view.backgroudTintView(self.cgfScaleContainerView)
            self.cgfScaleContainerView.backgroundColor = UIColor.appColor(.startImageBorderColor)
            cfgScalePopUpVC.popoverPresentationController?.sourceView = sender
            cfgScalePopUpVC.popoverPresentationController?.delegate = self
            topVC.present(cfgScalePopUpVC, animated: true)
        }
    }
    
    private func showHideImagePreviewContainer(){
        if self.inputImageView.image != nil{
            self.inputImageView.isHidden = false
        }else{
            self.inputImageView.isHidden = true
        }
    }
    
    //MARK: Aspect Ratio Container Actions
    @IBAction func changeSizeOfImageAction(_ sender: UIButton) {
        for rationButton in ratioButtonsCollection{
            if rationButton == sender{
                rationButton.isSelected = true
            }else{
                rationButton.isSelected = false
            }
        }
        manageAspectRatioButton()
        var currentAspectRatio: AIArtDataModel.AspectRatio = .square
        switch sender {
        case ratioButton_1_1: currentAspectRatio = .square
        case ratioButton_2_3: currentAspectRatio = .ratio2_3
        case ratioButton_3_2: currentAspectRatio = .ratio3_2
        case ratioCustomButton: currentAspectRatio = .custom(CGSize(width: 512, height: 512))
        default: break
        }
        
        delegate?.didSelectAspectSize(aspectSize: currentAspectRatio)
    }
    
    @objc func onSeedForLatentNoiseAction(_ sender: CustomSwitch) {
        print(#function)
        seedNumberTextField.text = nil
        seedNumberTextField.isEnabled = !sender.isOn
//        if !sender.isOn{
            self.delegate?.didEnterSeedValue(seed: 0)
//        }
    }
    
    @IBAction func selectSamplingEngineAction(_ sender: UIButton) {
        print(#function)
        if let topVC = UIApplication.topViewController(){
            topVC.view.backgroudTintView(self.samplerEngineListButtonView)
            self.samplerEngineListButtonView.backgroundColor = UIColor.appColor(.startImageBorderColor)
            samplerEngineListVC.popoverPresentationController?.sourceView = sender
            samplerEngineListVC.popoverPresentationController?.delegate = self
            topVC.present(samplerEngineListVC, animated: true)
        }
    }
    
    @objc func enableSmaplerEngineAction(_ sender: CustomSwitch) {
        print(#function)
        // Disable Sample Engine and set Autometic when CLIP Guidance will on
        samplingEngineButton.isEnabled = !sender.isOn
        samplerEngineListVC.popUpDataVM.didSelectSamplerEngine(atIndex: 0)
        self.didSelectSamplerEngine(samplerEngineListVC.popUpDataVM.currentSamplerEngine)
    }
    
}

extension ExpertModeView: PopUpDataDelegate{
    
    private func dismissPopUpView(){
        self.stableEngineContainerView.backgroundColor = UIColor.clear
        self.samplerEngineListButtonView.backgroundColor = .clear
        self.stepsContainerView.backgroundColor = .clear
        self.cgfScaleContainerView.backgroundColor = .clear
    }
    
    func popUpListControllerControllerDidDismiss() {
        self.dismissPopUpView()
        popUpViewDelegate?.popUpListControllerControllerDidDismiss()
    }
    
   
    func didChangeSteps(type: PopUpListType, steps: Int, event: UITouch.Phase) {
        self.setValues(type: type, value: steps)
        popUpViewDelegate?.didChangeSteps(type: type, steps: steps, event: event)
    }
    
    func didSelectStableEngine(_ stableEngine: AIArtDataModel.AIStabileEngine) {
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let textColor = UIColor.appColor(.appTextLightGray)
        let stablibityEngine = stableEngine.engine().title.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .center)
        self.stableEngineButton.setAttributedTitle(stablibityEngine, for: .normal)
        popUpViewDelegate?.didSelectStableEngine(stableEngine)
    }
    
    func didSelectSamplerEngine(_ samplerEngine: AIArtDataModel.SamplerEngine) {
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let textColor = UIColor.appColor(.appTextLightGray)
        let samplerEngineAtt = samplerEngine.rawValue.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left,lineBrackMode: .byTruncatingTail)
        self.samplerEngineLabel.attributedText = samplerEngineAtt
        popUpViewDelegate?.didSelectSamplerEngine(samplerEngine)
    }
}

extension ExpertModeView: ImageSelectionPopUpDelegate{
    func removeSelectedImage() {
        self.inputImageView.image = nil
        showHideImagePreviewContainer()
    }
    
    func replaceSelectedImage() {
        if let topVC = UIApplication.topViewController(){
            ImagePickerHandler.shared.showAttachmentActionSheet(vc: topVC)
            ImagePickerHandler.shared.imagePickedHandler = { [weak self](image) in
                Helper.dispatchMain {
                    self?.inputImageView.image = image
                    self?.delegate?.didSelectInputImage(inputImage: image)
                    self?.showHideImagePreviewContainer()
                }
            }
        }
    }
}


extension ExpertModeView: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        debugPrint(#function)
        self.dismissPopUpView()
        popUpViewDelegate?.popUpListControllerControllerDidDismiss()
    }
}

extension ExpertModeView{
    
   private func setUpUIDesign(){
       negativePromptContainerView.blurViewEffect(withAlpha: 0.7, cornerRadius: negativePromptContainerView.bounds.height/2)
       negativePromptContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: negativePromptContainerView.bounds.height/2)
       let blurAplha: CGFloat = 0.9
       
       promptStyleContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       promptStyleContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       listOfPromptContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       listOfPromptContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)

       randomPromptContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       randomPromptContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)

       stableEngineContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       stableEngineContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       imputImageContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       imputImageContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       stepsContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       stepsContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       cgfScaleContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       cgfScaleContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       aspectRatioContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       aspectRatioContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       seedContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       seedContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
       samplerContainerView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 15)
       samplerContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
       
//       samplerEngineListButtonView.blurViewEffect(withAlpha: blurAplha, cornerRadius: 10)
       samplerEngineListButtonView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 10)
       
       
    }
    
    private func setUpUIFont() {
        let fontSize14 = Font(.installed(.PadaukRegular), size: .standard(.h4)).instance
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let fontSize17 = Font(.installed(.PadaukRegular), size: .custom(17)).instance

        let textColor = UIColor.appColor(.appTextLightGray)
        
        let negativeTextLabel = negativePromptLabel.text?.attributedTo(font: fontSize14, spacing: 0, color: textColor,alignment: .center)
        negativePromptLabel.attributedText = negativeTextLabel
        
        let negativeText = negativePromptTextView.text?.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        negativePromptTextView.attributedText = negativeText
      
        let style = promptStyleButton.currentTitle?.attributedTo(font: fontSize17, spacing: 0, color: textColor,alignment: .center)
        promptStyleButton.setAttributedTitle(style, for: .normal)
        
        let listOfPrompt = listOfPromptButton.currentTitle?.attributedTo(font: fontSize17, spacing: 0, color: textColor,alignment: .center)
        listOfPromptButton.setAttributedTitle(listOfPrompt, for: .normal)
        
        let randomPrompt = randomPromptButton.currentTitle?.attributedTo(font: fontSize17, spacing: 0, color: textColor,alignment: .center)
        randomPromptButton.setAttributedTitle(randomPrompt, for: .normal)
        
        let stablibityEngine = stableEngineButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .center)
        stableEngineButton.setAttributedTitle(stablibityEngine, for: .normal)
        
        let fontSize19 = Font(.installed(.PadaukRegular), size: .custom(19)).instance

        let inputImageAtt = inputImageLabel.text?.attributedTo(font: fontSize19, spacing: 0, color: textColor,alignment: .center)
        inputImageLabel.attributedText = inputImageAtt
       
        let seedDetail =  " - The seed used to generate your image"
        var seedTitleAttr = "Seed".attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        let fontSize15 = Font(.installed(.PadaukRegular), size: .custom(15)).instance
        let seedDetailAttr = seedDetail.attributedTo(font: fontSize15, spacing: 0, color: textColor,alignment: .left)
        seedTitleAttr.append(seedDetailAttr)
        seedTitleLabel.attributedText = seedTitleAttr
        
        let seedNumberAttr = seedNumberTextField.text?.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        seedNumberTextField.attributedText = seedNumberAttr
        
        let randomSeedLbl = randomSeedLabel.text?.attributedTo(font: fontSize17, spacing: 0, color: textColor,alignment: .left)
        randomSeedLabel.attributedText = randomSeedLbl
        
        let samplerDetail = " - Enabling CLIP Guidance can help to\n improve image results for complex prompts or\n larger resolutions. It can also make images look\n more realistic."
        let samplerAttr = "Sampler".attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        let detailAttr = samplerDetail.attributedTo(font: fontSize15, spacing: 0, color: textColor,alignment: .left)
        samplerAttr.append(detailAttr)
        samplerTitleLabel.attributedText = samplerAttr
       
        
        samplerEngineLabel.attributedText = samplerEngineLabel.text?.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .left)
        
        clipGuidanceLabel.attributedText = clipGuidanceLabel.text?.attributedTo(font: fontSize17, spacing: 0, color: textColor,alignment: .center)
    }
    
    private func setValues(type: PopUpListType, value: Int) {
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let textColor = UIColor.appColor(.appTextLightGray)
        
        switch type {
        case .steps:
            let title = "Steps - \(value)"
            let stepsButtonAtt = title.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .center)
            stepsButton.setAttributedTitle(stepsButtonAtt, for: .normal)
        case .cfgScale:
            let title = "CFG Scale - \(value)"
            let cfgScaleButtonAtt = title.attributedTo(font: fontSize18, spacing: 0, color: textColor,alignment: .center)
            cgfScaleButton.setAttributedTitle(cfgScaleButtonAtt, for: .normal)
        default: break
        }
    }
}

extension ExpertModeView: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        debugPrint(#function, "textField.text ",textField.text ?? "")
        if let seedValue = textField.text{
            delegate?.didEnterSeedValue(seed: Int64(seedValue) ?? 0)
        }
    }
    
}


