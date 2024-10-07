//
//  PopUpListViewController.swift
//  DreamAI
//
//  Created by iApp on 22/12/22.
//

import UIKit



class PopUpListViewController: UIViewController {
        
    weak var delegate: PopUpDataDelegate?
    weak var imageDelegate: ImageSelectionPopUpDelegate?
    public var popUpDataVM = PopUpDataViewModel()
    
    @IBOutlet weak var popUpListTableView: UITableView!
    @IBOutlet weak var crosePopUpListButton: UIButton!
    
    //MARK: Slider PopUp Container View
    @IBOutlet weak var sliderPopUpContainerView: UIView!
    @IBOutlet weak var sliderPopUpTitleLabel: UILabel!
    @IBOutlet weak var sliderPopUpCancelButton: UIButton!
    @IBOutlet weak var sliderPopUpDescription: UILabel!
    @IBOutlet weak var expertModelSlider: UISlider!
    private var previousStepValue: CGFloat = 0
    public var enableStep: Bool = false

//    @IBOutlet weak var expertModelSlider: SummerSlider!
    
    //MARK: Select Remove image popUp Views
    @IBOutlet weak var selectImagePopUpContainerView: UIView!
    
    @IBOutlet weak var replaceImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
//        self.setUpSliderUI()
        setUpPopUI()
        self.preferredContentSize = popUpDataVM.preferredContentSize
        expertModelSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if popUpDataVM.popUpListType == .imageSelection{
           
        }
        switch popUpDataVM.popUpListType {
        case .imageSelection:
            replaceImageButton.border(width: 1, color: .textLightGray).corner(cornerRadius: replaceImageButton.bounds.height/2)
            removeImageButton.border(width: 1, color: .textLightGray).corner(cornerRadius: removeImageButton.bounds.height/2)
        case .cfgScale,.steps:
            setUpSliderUI()
        default:
            break
        }
        
        setUpSliderUI()
    }
    
    private func setUpFont(){
        
        
        
    }
    
    func setUpPopUI(){
//        sliderPopUpContainerView.isHidden = popUpDataVM.shouldShowList
        let data = popUpDataVM.popUpViewWithSlider()
        sliderPopUpTitleLabel.text = data?.title
        
        let font13 = Font(.installed(.PadaukRegular), size: .standard(.size13)).instance
        let descriptionAtt = data?.description.attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .left)
        sliderPopUpDescription.attributedText = descriptionAtt
        
        expertModelSlider.minimumValue = data?.minimumValue ?? 0
        expertModelSlider.maximumValue = data?.maximumValue ?? 10
        
        
        selectImagePopUpContainerView.isHidden = true
        sliderPopUpContainerView.isHidden = true
        popUpListTableView.isHidden = true
        crosePopUpListButton.isHidden = true
        
        switch popUpDataVM.popUpListType{
        case .steps:
            expertModelSlider.value = Float(popUpDataVM.stepsValue)
            sliderPopUpTitleLabel.text = (popUpDataVM.popUpViewWithSlider()?.title ?? "") + " - \(popUpDataVM.stepsValue)"
            sliderPopUpContainerView.isHidden = false
        case .cfgScale:
            expertModelSlider.value = Float(popUpDataVM.cfgScaleValue)
            sliderPopUpTitleLabel.text = (popUpDataVM.popUpViewWithSlider()?.title ?? "") + " - \(popUpDataVM.cfgScaleValue)"
            sliderPopUpContainerView.isHidden = false
        case .imageSelection:
            selectImagePopUpContainerView.isHidden = false
        default:
            popUpListTableView.isHidden = false
            crosePopUpListButton.isHidden = false
        }
        
        let font20 = Font(.installed(.PadaukRegular), size: .standard(.h1)).instance
        let sliderTitleAtt = sliderPopUpTitleLabel.text?.attributedTo(font: font20, spacing: 0, color: .white,alignment: .left)
        sliderPopUpTitleLabel.attributedText = sliderTitleAtt
        
        
        self.view.blurViewEffect(withAlpha: 1, cornerRadius: 15)
//        listOfPromptContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: 15)
    }
    
    private func setUpSliderUI(){

        expertModelSlider.setMinimumTrackImage(UIImage(named: "selectedSider"), for: UIControl.State.normal)
        expertModelSlider.setMaximumTrackImage(UIImage(named: "unSelectSider"), for: UIControl.State.normal)
        
        let numberOfSteps: Int = popUpDataVM.numberOfSetp
        if numberOfSteps <= 0{
            return
        }
        let oldCircles = expertModelSlider.subviews.filter({$0.tag == 1111111})
        oldCircles.forEach { circle in
            circle.removeFromSuperview()
        }
        for number in 0...numberOfSteps{
            let xPosition = number * (Int(expertModelSlider.bounds.width)/numberOfSteps)
            let circle = UIView(frame: CGRect(x: xPosition + 3, y: 9, width: 4, height: 4))
            circle.tag = 1111111
            circle.backgroundColor = UIColor.appColor(.appBlueColor)
            circle.layer.cornerRadius = 2
            expertModelSlider.insertSubview(circle, at: 0)
        }
    }
    
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            let newValue = Int(slider.value)
            if newValue != Int(previousStepValue){
                debugPrint("newValue changed",newValue)
                if enableStep{
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                let titleValue = (popUpDataVM.popUpViewWithSlider()?.title ?? "") + " - \(newValue)"
                
                let font20 = Font(.installed(.PadaukRegular), size: .standard(.h1)).instance
                let sliderTitleAtt = titleValue.attributedTo(font: font20, spacing: 0, color: .white)
                sliderPopUpTitleLabel.attributedText = sliderTitleAtt
                delegate?.didChangeSteps(type: popUpDataVM.popUpListType, steps: newValue, event: touchEvent.phase)
            }
            slider.setValue(Float(newValue), animated: false)
            previousStepValue = CGFloat(newValue)
        }
    }
    
    @IBAction func sliderPopUpCrossAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.delegate?.popUpListControllerControllerDidDismiss()
    }
    @IBAction func replaceImageAction(_ sender: UIButton) {
//        self.dismiss(animated: true)
        self.delegate?.popUpListControllerControllerDidDismiss()
        self.dismiss(animated: false) {
            self.imageDelegate?.replaceSelectedImage()
        }
    }
    @IBAction func removeImageAction(_ sender: UIButton) {
        imageDelegate?.removeSelectedImage()
        self.dismiss(animated: true)
        self.delegate?.popUpListControllerControllerDidDismiss()

    }
}

extension PopUpListViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func registerCell(){
        popUpListTableView.registerTableCell(identifier: ModifiersTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpDataVM.numberOfEngine
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifiersTableCell.identifier, for: indexPath) as? ModifiersTableCell
        var title: String = ""
        
        let isSelected = popUpDataVM.isSelected(atIndex: indexPath.item)
        
        var textColor: AssetsColor =  isSelected ? .appBlueColor :.appTextLightGray
        
        if popUpDataVM.popUpListType == .engine{
            let stableEngine = popUpDataVM.stableEngine(atIndex: indexPath.item)
            title = stableEngine.engine().title
            if stableEngine == .inpainting_v1_0 || stableEngine == .inpainting_512_v2_0{
                textColor = .appTextPlaceholder
            }
            cell?.configureCell(withStableEngine: stableEngine, color: textColor)
        }else{
            let stableEngine = popUpDataVM.sampleEngine(atIndex: indexPath.item)
            title = stableEngine.rawValue
            cell?.configureCell(withStableEngine: title,color: textColor)
        }
      
       
      
    return cell ?? UITableViewCell()
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if popUpDataVM.popUpListType == .engine{
            let stableEngine = popUpDataVM.stableEngine(atIndex: indexPath.item)
            if stableEngine == .inpainting_v1_0 || stableEngine == .inpainting_512_v2_0{
                return
            }
            popUpDataVM.didSelectStabilityEngine(atIndex: indexPath.item)
            delegate?.didSelectStableEngine(popUpDataVM.currentStabileEngine)
        }else{
            popUpDataVM.didSelectSamplerEngine(atIndex: indexPath.item)
            delegate?.didSelectSamplerEngine(popUpDataVM.currentSamplerEngine)
        }
        tableView.reloadData()
        self.dismiss(animated: true)
        self.delegate?.popUpListControllerControllerDidDismiss()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
     
}
