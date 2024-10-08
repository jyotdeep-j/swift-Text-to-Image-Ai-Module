//
//  BSLoader.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 07.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSide : CGFloat = 35.0
let loaderSpinnerMarginTop : CGFloat = 20.0
let loaderTitleMargin : CGFloat = 5.0

open class SwiftLoader: UIView {
    
    fileprivate var coverView : UIView?
    var titleLabel : UILabel?
    fileprivate var loadingView : SwiftLoadingView?
    fileprivate var animated : Bool = true
    fileprivate var canUpdated = false
    fileprivate var title: String?
    
    fileprivate var config : Config = Config() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override open var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRect(x: 0,y: 0,width: Config().size,height: Config().size))
        }
        return Singleton.instance
    }
    
    open class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    open class func show(title: String?, animated : Bool) {
        DispatchQueue.main.async {
            if let currentWindow = UIWindow.key {
            
            //guard let currentWindow : UIWindow = AppDelegate.shared.window else {return}
            let loader = SwiftLoader.sharedInstance
            loader.canUpdated = true
            loader.animated = animated
            loader.title = title
            loader.update()
            let height : CGFloat = UIScreen.main.bounds.size.height
            let width : CGFloat = UIScreen.main.bounds.size.width
            let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
            loader.center = center
            if (loader.superview == nil) {
                loader.coverView = UIView(frame: currentWindow.bounds)
                loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
                currentWindow.addSubview(loader.coverView!)
                currentWindow.addSubview(loader)
                loader.start()
            }
         }
        }
    }
    
    open class func hide() {
        let loader = SwiftLoader.sharedInstance
        loader.stop()
    }
    
    open class func setConfig(_ config : Config) {
        let loader = SwiftLoader.sharedInstance
        loader.config = config
        loader.frame = CGRect(x: 0,y: 0,width: loader.config.size,height: loader.config.size)
    }
    
    /**
    Private methods
    */
    
    fileprivate func setup() {
        self.alpha = 0
        self.update()
    }
    
    fileprivate func start() {
        self.loadingView?.start()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
                    
            });
        } else {
            self.alpha = 1
        }
    }
    
    fileprivate func stop() {
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    self.coverView?.removeFromSuperview()
                    self.removeFromSuperview()

                    self.loadingView?.stop()
            });
        } else {
            self.alpha = 0
            self.coverView?.removeFromSuperview()
            self.removeFromSuperview()

            self.loadingView?.stop()
        }
    }
    
    fileprivate func update() {
      //self.backgroundColor = self.config.backgroundColor
        self.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: CGRect(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - loaderTitleMargin*2, height: 42.0))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - loaderTitleMargin*2, height: 42.0)
        }
        
        self.titleLabel?.font = self.config.titleTextFont
      //self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.textColor = .white
        self.titleLabel?.text = self.title
        self.titleLabel?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(x: loaderSpinnerMarginSide, y: yOffset, width: loadingViewSize, height: loadingViewSize)
        }
        return CGRect(x: loaderSpinnerMarginSide, y: loaderSpinnerMarginTop, width: loadingViewSize, height: loadingViewSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    *  Loader View
    */
    class SwiftLoadingView : UIView {
        
        fileprivate var lineWidth : Float?
        fileprivate var lineTintColor : UIColor?
        fileprivate var backgroundLayer : CAShapeLayer?
        fileprivate var isSpinning : Bool?
        
        fileprivate var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
        Setup loading view
        */
        
        fileprivate func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            self.backgroundLayer = CAShapeLayer()
          //self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.strokeColor = UIColor.white.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        fileprivate func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            //self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.strokeColor = UIColor.white.cgColor
        }
        
        /**
        Draw Circle
        */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        fileprivate func drawBackgroundCircle(_ partial : Bool) {
            let startAngle : CGFloat = CGFloat(Double.pi) / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat(Double.pi)) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(Double.pi)) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        /**
        Start and stop spinning
        */
        
        fileprivate func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0 as Double)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        fileprivate func stop() {
            self.drawBackgroundCircle(false)
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    
    /**
    * Loader config
    */
    public struct Config {
        
        /**
        *  Size of loader
        */
        public var size : CGFloat = 120.0
        
        /**
        *  Color of spinner view
        */
        public var spinnerColor = UIColor.black
        
        /**
        *  S
        */
        public var spinnerLineWidth :Float = 1.0
        
        /**
        *  Color of title text
        */
        public var titleTextColor = UIColor.black
        
        /**
        *  Font for title text in loader
        */
        public var titleTextFont : UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /**
        *  Background color for loader
        */
        public var backgroundColor = UIColor.white
        
        /**
        *  Foreground color
        */
        public var foregroundColor = UIColor.clear
        
        /**
        *  Foreground alpha CGFloat, between 0.0 and 1.0
        */
        public var foregroundAlpha:CGFloat = 0.0
        
        /**
        *  Corner radius for loader
        */
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
