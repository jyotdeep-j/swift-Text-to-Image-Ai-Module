//
//  WelcomeScreenCVCell.swift
//  ScreenRecorder
//
//  Created by iApp on 03/09/21.
//

import UIKit
import AVFoundation

class WelcomeScreenCVCell: UICollectionViewCell {
    static let Identifier = "WelcomeScreenCVCell"
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bottomViewCenterAligned: UIView!
    @IBOutlet weak var bottomViewLeftAligned: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    
    @IBOutlet weak var shadowImageBottomConstraint: NSLayoutConstraint!
    
    
    var avAvAsset                                           : AVAsset?          = nil
    var avPlayerItem                                        : AVPlayerItem?     = nil
    var avPlayer                                            : AVPlayer?         = nil
    var avPlayerLayer                                       : AVPlayerLayer?    = nil
    
    
    
    
    
    let screen1 = (welcomeText: "Turn your words into art with ", attri: AppDetail.appName,buttonTitle:"Start Creating FREE")
    let screen2 = (welcomeText: "Enter Prompt & \n Choose ", attri: "Style",buttonTitle:"Continue")
    let screen3 = (welcomeText: "Choose From \n", attri: "Inspirations",buttonTitle:"Continue")
    let screen4 = (welcomeText: "Your Inspiration is \n", attri: "Ready",secondStr: " to use" ,buttonTitle:"Get Started")

    
    
    var videoUrlsArray:[URL] {
        get {
            let introVideoNames  : [String]   = ["Comap 1_2"]
            var urlArray = [URL]()
            for name in introVideoNames {
                if let videoUrl = Bundle.main.url(forResource: name, withExtension: "mp4") {
                    urlArray.append(videoUrl)
                }
            }
            return urlArray
        }
    }

//    let screen2 = (Text1: "Enter Prompt & \nChoose Style", Text2: "Video editor ", Text3: "Perfect Video editing \nfor Streamers")
//    let screen3 = (Text1: "Face Cam", Text2: "Reactions", Text3: "To your Favourite Recordings")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avPlayerLayer?.frame = self.bounds
    }
    
    private func applyGradientAndCornerRadius() {
        self.addGradientLayer(continueBtn)
        continueBtn.layer.cornerRadius = 10.0
        continueBtn.clipsToBounds = true
    }
    
    
    
    func setAVplayer(videoUrl:URL,view:UIView,frame:CGRect) {
        
        dellocAVPlayer()
        avAvAsset = AVAsset(url: videoUrl)
        avPlayerItem = AVPlayerItem(asset: avAvAsset!)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
//        let parentViewHeight:CGFloat = 1774/1242 * frame.width //414/445
//        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: parentViewHeight)
        avPlayerLayer?.frame = frame
        avPlayerLayer?.videoGravity = .resizeAspect
        
        view.layer.addSublayer(avPlayerLayer!)
        
        avPlayer?.seek(to: .zero)
        avPlayer?.play()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem!)
        NotificationCenter.default.addObserver( self, selector: #selector(playerItemDidReachEnd(_:)),name: .AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
    }
    
    
    @objc func playerItemDidReachEnd(_ notification: Notification?) {
//        let playerItem = notification?.object as? AVPlayerItem
//        playerItem?.seek(to: .zero, completionHandler: nil)
//        avPlayer?.play()
        
        self.avPlayerLayer?.isHidden = true
    }
    
    @objc func didBecomActiveWelcome(_ notification: Notification?) {
        if let player = avPlayer {
            player.play()
        }
    }
    
    func dellocAVPlayer() {
        
        if avPlayer != nil {
            avPlayer?.pause()
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem!)
//            avPlayer?.currentItem?.removeObserve
            avPlayer = nil
        }
        if avPlayerLayer != nil {
            avPlayerLayer?.removeAllAnimations()
            avPlayerLayer?.removeFromSuperlayer()
            avPlayerLayer = nil
        }
        if avPlayerItem != nil {
            avPlayerItem = nil
        }
        
        if avAvAsset != nil {
            avAvAsset = nil
        }
    }
    
    private func addGradientLayer(_ sender: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = sender.bounds
        gradientLayer.colors = [UIColor(red: 250/255.0, green: 92/255.0, blue: 140/255.0, alpha: 1.0).cgColor, UIColor(red: 244/255.0, green: 47/255.0, blue: 84/255.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0,0.5]
        sender.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupFirstScreen() {
        
        setAVplayer(videoUrl: videoUrlsArray.first!, view: self, frame: self.bounds)
        
//        if SCREEN_HEIGHT < 812{
//            bgImageView.image = UIImage(named: "welcome1-plus")
//        }else{
            bgImageView.image = UIImage(named: "MicrosoftTeams-image (2)")
//        }

        
//        let fontSize32 = Font(.installed(.appBold), size: .standard(.size32)).instance
        let fontSize25 = Font(.installed(.appRegular), size: .standard(.size26)).instance

//        let titleFont = Font(.installed(.appBold), size: .standard(.size23)).instance
        
        let titleFontasefr = Font(.installed(.myRiadBold), size: .standard(.size26)).instance
        
        let titleAttribute = screen1.welcomeText.attributedTo(font: fontSize25, spacing: 1.33, color: .black,alignment: .left)
        
        let titleAttribute2 = screen1.attri.attributedTo(font: titleFontasefr, spacing: 1.33, color: .red ,alignment: .left)

        titleAttribute.append(titleAttribute2)
        
        
        appNameLbl.attributedText = titleAttribute

        let buttonFont = Font(.installed(.myRiadBold), size: .standard(.h1)).instance
        let attString = screen1.buttonTitle.attributedTo(font: buttonFont, spacing: 1.5, color: .black)//.underline(1)
        continueBtn.setAttributedTitle(attString, for: .normal)
        shadowImageBottomConstraint.constant = 0
//        bottomViewLeftAligned.isHidden = true
//        bottomViewCenterAligned.isHidden = false
//        Helper.dispatchMain {
//            self.applyGradientAndCornerRadius()
//        }
    }
    
    func setupSecondScreen() {
//        if SCREEN_HEIGHT < 812{
//            bgImageView.image = UIImage(named: "welcome2-plus")
//        }else{
            bgImageView.image = UIImage(named: "Screen2")
//        }

        let fontSize32 = Font(.installed(.appBold), size: .standard(.size32)).instance
        let fontSize25 = Font(.installed(.appBold), size: .standard(.size25)).instance

        let titleFont = Font(.installed(.appBold), size: .standard(.size23)).instance
        
        let titleAttribute = screen2.welcomeText.attributedTo(font: fontSize25, spacing: 1.16, color: .black,alignment: .center)
        
        let titleAttribute2 = screen2.attri.attributedTo(font: fontSize32, spacing: 1.16, color: UIColor(named: "appGreen") ,alignment: .center)

        titleAttribute.append(titleAttribute2)
        
        
        appNameLbl.attributedText = titleAttribute


        let attString = screen2.buttonTitle.attributedTo(font: titleFont, spacing: 0.75, color: .white)//.underline(1)
        continueBtn.setAttributedTitle(attString, for: .normal)
        shadowImageBottomConstraint.constant = -50

    }
    
    func setupThirdScreen() {

        bgImageView.image = UIImage(named: "Welcome_screen3")

        let fontSize32 = Font(.installed(.appBold), size: .standard(.size32)).instance
        let fontSize25 = Font(.installed(.appBold), size: .standard(.size25)).instance

        let titleFont = Font(.installed(.appBold), size: .standard(.size23)).instance
        
        let titleAttribute = screen3.welcomeText.attributedTo(font: fontSize25, spacing: 1.16, color: .black,alignment: .center)
        
        let titleAttribute2 = screen3.attri.attributedTo(font: fontSize32, spacing: 1.16, color: UIColor(named: "appGreen") ,alignment: .center)

        titleAttribute.append(titleAttribute2)
        
        appNameLbl.attributedText = titleAttribute

        let attString = screen3.buttonTitle.attributedTo(font: titleFont, spacing: 0.75, color: .white)//.underline(1)
        continueBtn.setAttributedTitle(attString, for: .normal)
        shadowImageBottomConstraint.constant = -70
    }
    
    
    func setupFourthScreen() {
//        if SCREEN_HEIGHT < 812{
//            bgImageView.image = UIImage(named: "welcome3-plus")
//        }else{
            bgImageView.image = UIImage(named: "screen4")
//        }
        let fontSize32 = Font(.installed(.appBold), size: .standard(.size32)).instance
        let fontSize25 = Font(.installed(.appBold), size: .standard(.size25)).instance

        let titleFont = Font(.installed(.appBold), size: .standard(.size23)).instance
        
        let titleAttribute = screen4.welcomeText.attributedTo(font: fontSize25, spacing: 1.16, color: .black,alignment: .center)
        
        let titleAttribute2 = screen4.attri.attributedTo(font: fontSize32, spacing: 1.16, color: UIColor(named: "appGreen") ,alignment: .center)

        let titleAttribute3 = screen4.secondStr.attributedTo(font: fontSize25, spacing: 1.16, color: .black,alignment: .center)

        
        titleAttribute.append(titleAttribute2)
        titleAttribute.append(titleAttribute3)
        appNameLbl.attributedText = titleAttribute

        let attString = screen4.buttonTitle.attributedTo(font: titleFont, spacing: 0.75, color: .white)//.underline(1)
        continueBtn.setAttributedTitle(attString, for: .normal)
        shadowImageBottomConstraint.constant = -100

//        bottomViewLeftAligned.isHidden = false
//        bottomViewCenterAligned.isHidden = true
//        Helper.dispatchMain {
//            self.applyGradientAndCornerRadius()
//        }
    }

}
