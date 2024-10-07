//
//  CustomAspectRatioView.swift
//  DreamAI
//
//  Created by iApp on 30/12/22.
//

import UIKit
import AVFoundation

protocol CustomAspectRatioDelegate: AnyObject{
    func didSelectCustomAspectSize(aspectSize: AIArtDataModel.AspectRatio)
}
class CustomAspectRatioView: UIView {

    weak var delegate: CustomAspectRatioDelegate?

    @IBOutlet weak var tintBackgroundView: UIView!
    
    @IBOutlet weak var blurBgContainerView: UIView!
    @IBOutlet weak var blurViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var aspectSizeContainerView: UIView!
    @IBOutlet weak var aspectSizeView: UIView!
     @IBOutlet weak var aspectSizeLabel: UILabel!
    
    
    @IBOutlet weak var widthTitleLabel: UILabel!
    @IBOutlet weak var widthValueLabel: UILabel!
    @IBOutlet weak var widthValueSlider: UISlider!
    
    
    @IBOutlet weak var heightTitleLabel: UILabel!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var heightValueSlider: UISlider!
    
    
    private var previousStepValue: CGFloat = 512

    /*
      // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpSliderView()
        self.setUpUIDesign()
        Helper.dispatchMainAfter(time: .now() + 0.1) {
            self.setUpSliderUI(slider: self.widthValueSlider)
            self.setUpSliderUI(slider: self.heightValueSlider)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var lastAspectSize: CGSize = CGSize(width: 512, height: 512){
        didSet{
            updateSize(size: lastAspectSize)
            
            let aspectWidthValue = (lastAspectSize.width - 512)/64
            let aspectHeightValue = (lastAspectSize.height - 512)/64
            widthValueSlider.value = Float(aspectWidthValue)
            heightValueSlider.value = Float(aspectHeightValue)
            let aspectFrame = AVMakeRect(aspectRatio: lastAspectSize, insideRect: aspectSizeContainerView.bounds)
            self.aspectSizeView.frame = aspectFrame
        }
    }
    
    
    public func showView(){
//        blurViewBottomConstraint.constant = -630
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.tintBackgroundView.alpha = 1
        }
        
        blurViewBottomConstraint.constant = 30
        UIView.animate(withDuration: 0.3, delay: 0.05) {
            self.layoutIfNeeded()
        } completion: { isComplete in
            self.tintBackgroundView.mask(withRect: self.blurBgContainerView.frame, cornerRadius: 15,inverse: true)
        }
    }
    
    public func hideView(){
//        blurViewBottomConstraint.constant = -630
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.tintBackgroundView.alpha = 0
        }
        
        blurViewBottomConstraint.constant = -630
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.layoutIfNeeded()
        } completion: { isComplete in
            self.removeFromSuperview()
//            self.tintBackgroundView.mask(withRect: self.blurBgContainerView.frame, cornerRadius: 15,inverse: true)
        }
    }
    
    private func setUpUIDesign() {
        blurBgContainerView.blurViewEffect(withAlpha: 1.0, cornerRadius: 15)
        blurBgContainerView.corner(cornerRadius: 15)
        aspectSizeView.corner(cornerRadius: 15)
        
        doneButton.corner(cornerRadius: 7)
        let font20 = Font(.installed(.PadaukRegular), size: .standard(.h1)).instance
        let doneTitle = "Done".attributedTo(font: font20, spacing: 0, color: .black,alignment: .center)
        doneButton.setAttributedTitle(doneTitle, for: .normal)

        let sliderTitleAtt = titleLabel.text?.attributedTo(font: font20, spacing: 0, color: .white,alignment: .left)
        titleLabel.attributedText = sliderTitleAtt
        
        let font13 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
        let widthtitle = widthTitleLabel.text?.attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .left)
        widthTitleLabel.attributedText = widthtitle
        
        let heightTitle = heightTitleLabel.text?.attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .left)
        heightTitleLabel.attributedText = heightTitle
        
    }
    
    private func setUpSliderView(){
        widthValueSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        heightValueSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        widthValueSlider.minimumValue = 0
        widthValueSlider.maximumValue = 8
        heightValueSlider.minimumValue = 0
        heightValueSlider.maximumValue = 8
        
        widthValueSlider.value = 0
        heightValueSlider.value = 0
    }
    
    
    private func setUpSliderUI(slider: UISlider){

        slider.setMinimumTrackImage(UIImage(named: "selectedSider"), for: UIControl.State.normal)
        slider.setMaximumTrackImage(UIImage(named: "unSelectSider"), for: UIControl.State.normal)
        
        let numberOfSteps: Int = 8
        
        let oldCircles = slider.subviews.filter({$0.tag == 1111111})
        oldCircles.forEach { circle in
            circle.removeFromSuperview()
        }
        debugPrint("total width",slider.bounds.width)
        let trackRect = slider.trackRect(forBounds: slider.bounds)
        debugPrint("trackRect", trackRect)
        for number in 1...numberOfSteps{
            let xPosition = CGFloat(number) * (trackRect.width/CGFloat(numberOfSteps))
            debugPrint("xPosition ",xPosition)
            let circle = UIView(frame: CGRect(x: xPosition , y: 14, width: 4.0, height: 4.0))
            circle.tag = 1111111
            circle.backgroundColor = UIColor.appColor(.appBlueColor)
            circle.layer.cornerRadius = 2
            slider.insertSubview(circle, at: 0)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.removeBackgroundTintView()
//        self.removeFromSuperview()
        hideView()
    }
    
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            let newValue = Int(slider.value)
            
            debugPrint("newValue changed",newValue)
            
            debugPrint("newValue Size ",(newValue * 64) + 512)
       
            slider.setValue(Float(newValue), animated: false)

            if newValue != Int(previousStepValue){
                debugPrint("newValue changed",newValue)
                
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                let aspectWidth = (widthValueSlider.value * 64) + 512
                let aspectHeight = (heightValueSlider.value * 64) + 512
                let aspectSize = CGSize(width: CGFloat(aspectWidth), height: CGFloat(aspectHeight))
                let aspectFrame = AVMakeRect(aspectRatio: aspectSize, insideRect: aspectSizeContainerView.bounds)
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.aspectSizeView.frame = aspectFrame
                }
                updateSize(size: aspectSize)
               /* self.widthValueLabel.text = "\(Int(aspectWidth))"
                self.heightValueLabel.text = "\(Int(aspectHeight))"
                self.aspectSizeLabel.text = "\(Int(aspectWidth))x\(Int(aspectHeight))"*/
                self.delegate?.didSelectCustomAspectSize(aspectSize: .custom(aspectSize))
            }
            previousStepValue = CGFloat(newValue)
        }
    }
    
    func updateSize(size: CGSize){
  
        let font13 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
      
        let widthValue = "\(Int(size.width))".attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .right)
        widthValueLabel.attributedText = widthValue
        
        let heightValue = "\(Int(size.height))".attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .right)
        widthValueLabel.attributedText = widthValue
        heightValueLabel.attributedText = heightValue
        
        let aspectSizeTitle = "\(Int(size.width))x\(Int(size.height))".attributedTo(font: font13, spacing: 0, color: UIColor.appColor(.appTextLightGray), alignment: .center)
        aspectSizeLabel.attributedText = aspectSizeTitle
    }
}
