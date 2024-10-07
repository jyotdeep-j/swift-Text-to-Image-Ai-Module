//
//  ToolTipCustomView.swift
//  DreamAI
//
//  Created by iApp on 13/12/22.
//

import UIKit



class ToolTipCustomView: UIView {
    
    @IBOutlet weak var toolTipView: UIView!
    @IBOutlet weak var toolTipTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolTipContainerView: UIView!
    
//    @IBOutlet weak var congratsCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var congratsView: UIView!
    @IBOutlet weak var congratsImageView: UIImageView!
    
//    private var toolTipSetpCount: Int = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUpOfNewUserToolTip()
    }
    
   
    private func initialSetUpOfNewUserToolTip(){
        var topSpacing: CGFloat = 30
        if Devices.IS_IPHONE_6_8{
            topSpacing = 0
        }
        self.alpha = 0.0
        toolTipTopConstraint.constant = topSpacing
        self.toolTipContainerView.transform = CGAffineTransform(translationX: 0, y: -400)
    }
    
    public func presentNewUserTooTip(){
        applyAnimationToPresent(onView: toolTipContainerView)
    }
    
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {

        applyAnimationToDismiss(onView: toolTipContainerView)

        applyAnimationToDismiss(onView: congratsImageView)
    }
    
    func setUpCongratsView(){
        toolTipView.isHidden = true
        congratsView.isHidden = false
//        congratsCenterYConstraint.constant = 0
        congratsImageView.transform = CGAffineTransform(translationX: 0, y: -600)
        
        applyAnimationToPresent(onView: congratsImageView)
        
        
    }
    
    
    
//    func setGoodChoiceToolTip(){
//        var topSpacing: CGFloat = 200
//        if Devices.IS_IPHONE_6_8{
//            topSpacing = 170
//        }
//
//        toolTipTopConstraint.constant = topSpacing
//        toolTipImageView.image = UIImage(named: "GoodChoice")
//    }
    
    
 /*   func animateNewToAIPopUp(){
        
        var topSpacing: CGFloat = 60
        if Devices.IS_IPHONE_6_8{
            topSpacing = 30
        }
//        toolTipTopConstraint.constant = topSpacing
//        toolTipImageView.image = UIImage(named: "NewToAI")
       
//        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

       
        applyAnimationToPresent(onView: toolTipImageView)
        
       /* UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: [.curveEaseInOut]) {
//            self.layoutIfNeeded()
            self.toolTipImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.alpha = 1.0
        }*/
        
        
    }*/
    
    
    
    
    func applyAnimationToPresent(onView customView: UIView) {
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.calculationModeCubic,.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.60) {
                self.alpha = 1.0
                customView.transform = CGAffineTransform(translationX: 0, y: 20)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.70, relativeDuration: 0.10) {
                customView.transform = CGAffineTransform(translationX: 0, y: -10)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.10) {
                customView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }) { isComplete in
            
        }
    }
    
    
    func applyAnimationToDismiss(onView customView: UIView) {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeCubic,.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.20, relativeDuration: 0.10) {
                customView.transform = CGAffineTransform(translationX: 0, y: -10)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.70) {
                self.alpha = 0.0
                customView.transform = CGAffineTransform(translationX: 0, y: 800)
            }
           
        }) { isComplete in
            self.removeFromSuperview()
        }
    }
    
}
