//
//  CustomLoader.swift
//  DreamAI
//
//  Created by iApp on 18/11/22.
//

import Foundation
import Foundation
import UIKit
//import NVActivityIndicatorView
import UIKit
import QuartzCore
import CoreGraphics

import ImageIO
import MobileCoreServices

class CustomLoader {
    public static let sharedInstance = CustomLoader()
    var backImage = UIImageView()
    var loaderImage = UIImageView()
    var loaderBackGround = UIView()
    var titleLabel = UILabel()
    
    //var nvActiveIndicator                            : NVActivityIndicatorView!
     let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
     let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    
  let imgArray: [UIImage] = [#imageLiteral(resourceName: "Layer 40.png"),#imageLiteral(resourceName: "Layer 1.png"),#imageLiteral(resourceName: "Layer 2.png"),#imageLiteral(resourceName: "Layer 3.png"),#imageLiteral(resourceName: "Layer 4.png"),#imageLiteral(resourceName: "Layer 5.png"),#imageLiteral(resourceName: "Layer 6.png"),#imageLiteral(resourceName: "Layer 7.png"),#imageLiteral(resourceName: "Layer 8.png"),#imageLiteral(resourceName: "Layer 9.png"),#imageLiteral(resourceName: "Layer 10.png"),#imageLiteral(resourceName: "Layer 11.png"),#imageLiteral(resourceName: "Layer 12.png"),#imageLiteral(resourceName: "Layer 13.png"),#imageLiteral(resourceName: "Layer 14.png"),#imageLiteral(resourceName: "Layer 15.png"),#imageLiteral(resourceName: "Layer 16.png"),#imageLiteral(resourceName: "Layer 17.png"),#imageLiteral(resourceName: "Layer 18.png"),#imageLiteral(resourceName: "Layer 19.png"),#imageLiteral(resourceName: "Layer 20.png"),#imageLiteral(resourceName: "Layer 21.png"),#imageLiteral(resourceName: "Layer 22.png"),#imageLiteral(resourceName: "Layer 23.png"),#imageLiteral(resourceName: "Layer 24.png"),#imageLiteral(resourceName: "Layer 25.png"),#imageLiteral(resourceName: "Layer 26.png"),#imageLiteral(resourceName: "Layer 27.png"),#imageLiteral(resourceName: "Layer 28.png"),#imageLiteral(resourceName: "Layer 29.png"),#imageLiteral(resourceName: "Layer 30.png"),#imageLiteral(resourceName: "Layer 31.png"),#imageLiteral(resourceName: "Layer 32.png"),#imageLiteral(resourceName: "Layer 33.png"),#imageLiteral(resourceName: "Layer 34.png"),#imageLiteral(resourceName: "Layer 35.png"),#imageLiteral(resourceName: "Layer 36.png"),#imageLiteral(resourceName: "Layer 37.png"),#imageLiteral(resourceName: "Layer 38.png"),#imageLiteral(resourceName: "Layer 39.png")]
   
    private init(){
        backImage.frame = UIScreen.main.bounds
        backImage.backgroundColor = .clear
        backImage.alpha = 1.0
        backImage.isUserInteractionEnabled = true
        loaderBackGround.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH * 0.6, height: 30)
        loaderBackGround.backgroundColor = .clear
        loaderBackGround.center = backImage.center
        //loaderBackGround.layer.cornerRadius = loaderBackGround.frame.height/2
        loaderImage.image = UIImage(named: "ItunesArtwork")
        loaderImage.frame = loaderBackGround.frame
        loaderImage.center = loaderBackGround.center
        //self.animatedGif(from: imgArray)
        let animatedImage = UIImage.animatedImage(with: imgArray, duration: 1.0)
        loaderImage.image = animatedImage
        loaderImage.tintColor = UIColor.red
        backImage.addBlurEffect()
    }
    
    func show(){
        Helper.dispatchMain {
            if let currentWindow = UIWindow.key {
                currentWindow.addSubview(self.backImage)
                currentWindow.addSubview(self.loaderBackGround)
                currentWindow.addSubview(self.loaderImage)
                for subviewss in self.loaderBackGround.subviews{
                    if subviewss.tag == 101{
                        subviewss.removeFromSuperview()
                    }
                }
            }
        }
    }
    func hide(){
        Helper.dispatchMain {
           // self.nvActiveIndicator.stopAnimating()
            self.loaderImage.removeFromSuperview()
            self.loaderBackGround.removeFromSuperview()
            self.backImage.removeFromSuperview()
            self.titleLabel.text = ""
        }
    }
    
    func show(withMessage: String){
        Helper.dispatchMain {
            if let currentWindow = UIWindow.key {
                currentWindow.addSubview(self.backImage)
                currentWindow.addSubview(self.loaderBackGround)
                currentWindow.addSubview(self.loaderImage)
                
                
//
//                if (self.nvActiveIndicator != nil) {
//                    self.nvActiveIndicator.removeFromSuperview()
//                    self.nvActiveIndicator.stopAnimating()
//                    self.nvActiveIndicator.layer.removeAllAnimations()
//                    self.nvActiveIndicator = nil
//                  }
//                self.nvActiveIndicator = NVActivityIndicatorView(frame: self.loaderImage.bounds, type: .ballSpinFadeLoader, color: UIColor(named: "appGreen"), padding: 10)
//                self.loaderImage.addSubview(self.nvActiveIndicator)
//                self.nvActiveIndicator.startAnimating()
                self.addTitle(title: withMessage)
               
            }
        }
    }
    
    
    
    
    
    func addTitle(title:String){
        titleLabel.frame = CGRect.init(x: loaderBackGround.bounds.origin.x, y: loaderBackGround.bounds.origin.y + 50, width: loaderBackGround.frame.width, height: 30)
        let fontSize25 = Font(.installed(.appBold), size: .standard(.size15)).instance
        let titleAttribute = title.attributedTo(font: fontSize25, spacing: 1.0, color: .white,alignment: .center)
        titleLabel.attributedText = titleAttribute
        loaderBackGround.addSubview(self.titleLabel)
    }
    
 
}


extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        blurEffectView.alpha = 0.5
        self.addSubview(blurEffectView)
    }
}
