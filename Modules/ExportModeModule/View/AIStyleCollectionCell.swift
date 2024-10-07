//
//  AIStyleCollectionCell.swift
//  DreamAI
//
//  Created by iApp on 04/11/22.
//

import UIKit
import SDWebImage

class AIStyleCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var noneIconView: UIImageView!
    @IBOutlet weak var styleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    static let identifier = "AIStyleCollectionCell"
    
//    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageIconViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var proIconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        setupFont()
        setupUI()
    }

    public var isStyleSelected: Bool = false{
        didSet{
            if isStyleSelected {
                mainContainerView.layer.borderColor = UIColor.appColor(.appBlueColor)?.cgColor //UIColor(named: "appGreen")?.cgColor
                mainContainerView.layer.borderWidth = 2
            }else{
                mainContainerView.layer.borderWidth = 0
            }
        }
    }
    
    public func configureCell(with aiStyle: AIStyle) {
        
        let iconName = aiStyle.styleDetail().imageName
       
//        titleLabelHeightConstraint.constant = 23.67
        titleLabel.numberOfLines = 1
        noneIconView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
      /*  if !StoreManager.shared.isPurchased{
            proIconImageView.isHidden = !aiStyle.styleDetail().isPro
        }else{
            proIconImageView.isHidden = true
        }*/
        proIconImageView.isHidden = true
//        blurVisualEffectView.isHidden = true
        var textColor = UIColor.appColor(.appTextPlaceholder)
        titleLabel.isHidden = true
        switch aiStyle{
        case .none:
            titleLabel.isHidden = false
//            imageIconViewCenterConstraint.constant = 0
            noneIconView.isHidden = false
            noneIconView.image = UIImage(named: iconName)
            styleImageView.image = nil
            styleImageView.backgroundColor = .clear //UIColor.appColor(.appDarkGray)
//            blurVisualEffectView.isHidden = true
            textColor = UIColor.appColor(.appTextLightGray)
      /*  case .addModifiers:
            titleLabel.isHidden = false
            titleLabel.numberOfLines = 2
            titleLabelHeightConstraint.constant = 38
            imageIconViewCenterConstraint.constant = -10
            noneIconView.image = UIImage(named: iconName)
//            noneIconView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            noneIconView.isHidden = false
            styleImageView.image = nil
            styleImageView.backgroundColor = .clear//UIColor.appColor(.appDarkGray)
            blurVisualEffectView.isHidden = true
            textColor = UIColor.appColor(.appTextLightGray)*/
        default:
            noneIconView.isHidden = true
            styleImageView.image = UIImage(named: iconName)
        }
        switch aiStyle{
        case .none:
            if !isStyleSelected{
                mainContainerView.layer.borderWidth = 2
                mainContainerView.layer.borderColor = UIColor.init(red: 40/255, green: 40/255, blue: 42/255, alpha: 1).cgColor
            }
            let fontSize13 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
            let title = aiStyle.styleDetail().title
            let titleTextAttri = title.attributedTo(font: fontSize13, spacing: 0.60,lineSpacing: 5, color: textColor,alignment: .center)
            titleLabel.attributedText = titleTextAttri
        default: break
        }
        
       
    }
    
    
    public func configureCell(with socialMedia: SocialMediaType){
        let fontSize13 = Font(.installed(.appRegular), size: .standard(.h5)).instance
        let titleTextAttri = socialMedia.title.attributedTo(font: fontSize13, spacing: 0.60, color: UIColor.appColor(.appTextWhiteColor),alignment: .center)
        titleLabel.attributedText = titleTextAttri
        styleImageView.image = UIImage(named: socialMedia.title)
    }
    
    public func configureCell(withStabilityImage imageData: StabilityImages){
        noneIconView.isHidden = true
        proIconImageView.isHidden = true
        styleImageView.contentMode = .scaleAspectFit
        titleLabel.isHidden = true
        if let imageUrl = imageData.url{
            self.setImageFromUrl(imageUrl: imageUrl)
        }
    }
   
    
    
    public func configureCellWithFullPreview(withStabilityImage imageData: StabilityImages){
        self.clearCell()
        noneIconView.isHidden = true
        proIconImageView.isHidden = true
        styleImageView.contentMode = .scaleAspectFit
        titleLabel.isHidden = true
        if let imageUrl = imageData.url{
            self.setImageFromUrl(imageUrl: imageUrl)
        }
        mainContainerView.layer.cornerRadius = 0
    }
    
   
    
    
    public func addBlurAndLockLabel(){
       
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
//        let unloackLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 10, height: 18))
        let unloackLabel = UILabel()
        unloackLabel.bounds = CGRect(x: 0, y: 0, width: 70, height: 18)
//        let unloackLabel = UILabel(frame: CGRect(x: 5, y: (self.bounds.height/2) - 9, width: self.bounds.width - 10, height: 18))
        unloackLabel.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let fontRegular18 = Font(.installed(.myRiadBold), size: .standard(.size13)).instance
        let promptText = "UNLOCK".attributedTo(font: fontRegular18, spacing: 1, color: UIColor.appColor(.appRed),alignment: .center)
        unloackLabel.attributedText = promptText
        unloackLabel.tag = 10101010
        unloackLabel.backgroundColor = .white.withAlphaComponent(0.8)
        unloackLabel.layer.cornerRadius = 5
        unloackLabel.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.addSubview(unloackLabel)
    }
    
    
    private func clearCell(){
        let blurViews = self.subviews.filter({$0.isKind(of: UIVisualEffectView.self) || $0.tag == 10101010})
        blurViews.forEach { blurView in
            blurView.removeFromSuperview()
        }
    }
    
    private func setImageFromUrl(imageUrl: String) {
        if let finalUrl = URL(string: imageUrl){
            styleImageView.sd_setImage(with: finalUrl, placeholderImage: UIImage(named: "imgPlaceholder"), options: .progressiveLoad) { [weak self] (image, error, imageCacheType, url) in
                /*CustomLoader.sharedInstance.hide()
                Helper.dispatchMain {
                    if let imageSize = self?.styleImageView.image?.size {
//                        let imageviewFrame = AVMakeRect(aspectRatio: imageSize, insideRect: self!.mediaContainerView.bounds)
                        self?.mediaImageView.frame = imageviewFrame
                    }
                }*/
            }
        }
    }
}

extension AIStyleCollectionCell{
    
    private func setupUI(){
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.layer.masksToBounds = true
    }
    
//    private func setupFont(){
//        let fontSize13 = Font(.installed(.appRegular), size: .standard(.size13)).instance
//        let titleTextAttri = titleLabel.text?.attributedTo(font: fontSize13, spacing: 0.60, color: UIColor(named: "textLightGray"),alignment: .center)
//        titleLabel.attributedText = titleTextAttri
//    }
}
