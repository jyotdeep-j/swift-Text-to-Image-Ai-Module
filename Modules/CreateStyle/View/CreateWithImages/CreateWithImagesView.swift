//
//  CreateWithImagesView.swift
//  DreamAI
//
//  Created by iApp on 20/12/22.
//

import UIKit

protocol CreateWithImageDelegate: AnyObject{
    func willCreateImageAction(_ sender: UIButton)
    func didOptionImageCountSelectionViewPopUp(_ sender: UIButton)
}

//protocol CreateWithImageProtocol {
//    static var numberOfImages: Int { get set }
//}

class CreateWithImagesView: UIView {
    
    static let heightOfPopUpView: CGFloat = 130
    static let accessoryViewHeight: CGFloat = 45
    
    weak var delagate: CreateWithImageDelegate?
    
    @IBOutlet weak var blurContainerView: UIView!

    @IBOutlet weak var imagesButtonContainerView: UIView!
    @IBOutlet weak var imagesButton: UIButton!
    
    @IBOutlet weak var createButtonContainerView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var creditScoreLabel: UILabel!
    @IBOutlet weak var createButtonTitleLabel: UILabel!
    
    
    //MARK: Custom Input Accessory Outlets
    @IBOutlet weak var customInputAccessoryView: UIView!
    
    @IBOutlet weak var numberOfImagesAccessoryView: UIView!
    @IBOutlet weak var createButtonAccessoryView: UIView!
    
    @IBOutlet weak var createAccessoryButton: UIButton!
    
    @IBOutlet weak var numberOfImagesAccessoryButton: UIButton!
    public var createStyleType: CreateStyleType = .new
    
    var numberOfImages: Int = 1{
        didSet{
            self.setNumberOfImages()
            self.setCreateStyleButton()
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUIDesign()
        self.setCreateStyleButton()
        self.setNumberOfImages()
        self.setObservations()
        
        
        /*let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        customView.backgroundColor = UIColor.red
        prompTextView.inputAccessoryView = customView
        prompTextView.returnKeyType = .done*/
    }
    
    public func setUpInputAccessoryView(){
        customInputAccessoryView.isHidden = false
        blurContainerView.isHidden = true
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
            self.setCreateStyleButton()
          /*  if !isPurchased {
                self.numberOfImages = 2
            }*/
        }
 
    }
    
    private func setUpUIDesign(){
        blurContainerView.blurViewEffect(withAlpha: 1, cornerRadius: 0)
        imagesButtonContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: imagesButtonContainerView.bounds.height/2)
        createButtonContainerView.border(width: 1, color: .appBlueColor).corner(cornerRadius: createButtonContainerView.bounds.height/2)
//        createButtonAccessoryView.blurViewEffect(withAlpha: 1.0, cornerRadius: 0)
        numberOfImagesAccessoryView.blurViewEffect(withAlpha: 1.0, cornerRadius: 0)
    }
    
    
    public func show(){
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut) {
            self.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT - CreateWithImagesView.heightOfPopUpView, width: self.bounds.width, height: self.bounds.height)
        }
    }
    
    public func hide(){
        UIView.animate(withDuration: 0.3, delay: 0,options: .curveEaseInOut) {
            self.frame = CGRect(x: 0, y: ScreenSize.SCREEN_HEIGHT, width: self.bounds.width, height: self.bounds.height)
        }
    }
    
    private func setNumberOfImages(){
        let font = Font(.installed(.PadaukBold), size: .standard(.h3)).instance
        let imageText = "\(numberOfImages) images"
        let createStyleAttr = imageText.attributedTo(font: font, spacing: 0.4,lineSpacing: 0, color: UIColor.appColor(.appTextLightGray),alignment: .center)
        imagesButton.setAttributedTitle(createStyleAttr, for: .normal)
        
        let imagesfont = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance

        let createStyleAttr22 = imageText.attributedTo(font: imagesfont, spacing: 0.4,lineSpacing: 0, color: .white,alignment: .center)
        numberOfImagesAccessoryButton.setAttributedTitle(createStyleAttr22, for: .normal)
    }
    
    private func setCreateStyleButton() {
        
        let createTitle = self.createStyleType == .new ? "Create" : "Recreate"
        
        let createStyleFont = Font(.installed(.PadaukBold), size: .standard(.h1)).instance
        let createStyleAttr = createTitle.attributedTo(font: createStyleFont, spacing: 1.0,lineSpacing: 0, color: .white,alignment: .center)

        let offerOfCredit = "1 credit to create - "
        
        if StoreManager.shared.isPurchased {
            createButton.setAttributedTitle(createStyleAttr, for: .normal)
            createAccessoryButton.setAttributedTitle(createStyleAttr, for: .normal)
            createButtonTitleLabel.text = nil
            creditScoreLabel.text = nil
        }else {
            let creditAtt = Font(.installed(.PadaukRegular), size: .standard(.size13)).instance
            let creditCount = "1 Credit will be used".attributedTo(font: creditAtt, spacing: 1.0,lineSpacing: 0, color: .white,alignment: .center)
            createButtonTitleLabel.attributedText = createStyleAttr
            creditScoreLabel.attributedText = creditCount
            createButton.setAttributedTitle(nil, for: .normal)
            
            
            let font17 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
            let offerText =  offerOfCredit.attributedTo(font: font17, spacing: 1.0,lineSpacing: 0, color: .white,alignment: .center)
            offerText.append(createStyleAttr)
            createAccessoryButton.setAttributedTitle(offerText, for: .normal)
            
        }
        
        
    }
    
    
    @IBAction func selectSampleImagesAction(_ sender: UIButton) {
        delagate?.didOptionImageCountSelectionViewPopUp(sender)
    }
    
    
    @IBAction func createImageButtonAction(_ sender: UIButton) {
        delagate?.willCreateImageAction(sender)
    }
}
