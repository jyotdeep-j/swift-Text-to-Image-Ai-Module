//
//  UIViewExtensions.swift
//  CartoonMe
//
//  Created by iApp on 19/07/22.
//

import Foundation
import UIKit


extension UIView{
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func takeScreenshot(size:CGSize) -> UIImage?{
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    enum VerticalLocation: String {
        case bottom
        case top
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 3.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -3), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    
    
    func blurViewEffect(withAlpha alpha: CGFloat = 1.0, cornerRadius: CGFloat = 0){
        
        let blurViews = self.subviews.filter({$0 is UIVisualEffectView})
        blurViews.forEach { blurView in
            blurView.removeFromSuperview()
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.alpha = alpha
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.layer.masksToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.insertSubview(blurEffectView, at: 0)
    }
    
    func corner(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func border(width: CGFloat, color: AssetsColor) -> UIView{
        self.layer.borderColor = UIColor.appColor(color)?.cgColor
        self.layer.borderWidth = width
        return self
    }
    
    
    /*func blurredImage(with radius: CGFloat, atRect: CGRect) {
     //        guard let ciImg = CIImage(image: self) else { return nil }
     
     //        let cropedCiImg = ciImg.cropped(to: atRect)
     let blur = CIFilter(name: "CIGaussianBlur")
     //        blur?.setValue(cropedCiImg, forKey: kCIInputImageKey)
     blur?.setValue(radius, forKey: kCIInputRadiusKey)
     
     if let ciImgWithBlurredRect = blur?.outputImage,
     let outputImg = CIContext().createCGImage(ciImgWithBlurredRect, from: ciImgWithBlurredRect.extent) {
     let blurImage =  UIImage(cgImage: outputImg)
     let imageView = UIImageView(frame: atRect)
     imageView.image = blurImage
     self.insertSubview(imageView, at: 0)
     
     
     //            return UIImage(cgImage: outputImg)
     }
     }*/
    
    
    func removeBackgroundTintView(){
        let subView = self.subviews.filter({$0.tag == 1000001}).first
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            subView?.alpha = 0
        } completion: { isComplete in
            subView?.removeFromSuperview()
        }
    }
    
    func backgroudTintView(_ maskView: UIView,cornerRadius: CGFloat = 0){
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.appColor(.appBackground)?.withAlphaComponent(0.5)
        view.alpha = 0
        view.tag = 1000001
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        //        let frameWithSuper = sender.superview!.convert(sender.frame, from: controller.view)
        let frameWithSuper = maskView.superview!.convert(maskView.frame, to: self)
        debugPrint("frameWithSuper ",frameWithSuper)
        view.mask(withRect: frameWithSuper, cornerRadius: cornerRadius,inverse: true)
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            view.alpha = 1
        }
    }
    
    
    func mask(withRect maskRect: CGRect, cornerRadius: CGFloat, inverse: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        if (inverse) {
            path.addPath(UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath)
        }
        path.addPath(UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = path
        if (inverse) {
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }
        self.layer.mask = maskLayer;
    }
    
    

   /* func applyAnimationToPresent(onView customView: UIView) {
        
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
    }*/
    
    
    
    func animationBubbleEffect(duration: Double = 1, delay: Double = 0.5){
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [.calculationModeCubic,.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.20) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.30) {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.30) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }) { isComplete in
            UIView.animate(withDuration: 0.6) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    func showToast(message : String, frame: CGRect) {
        
        let toastLabel = UILabel(frame: frame)
        toastLabel.backgroundColor = UIColor(named: AssetsColor.startImageBGColor.rawValue)
        toastLabel.textColor = UIColor.white
        toastLabel.font = Font(.installed(.myRiadSemiBold), size: .standard(.size15)).instance
        toastLabel.textAlignment = .center;
        toastLabel.text = " \(message) "
        toastLabel.numberOfLines = 2
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIImage {
    
    func blurredImage(with context: CIContext, radius: CGFloat, atRect: CGRect) -> UIImage? {
        guard let ciImg = CIImage(image: self) else { return nil }

        let cropedCiImg = ciImg.cropped(to: atRect)
        let blur = CIFilter(name: "CIGaussianBlur")
        blur?.setValue(cropedCiImg, forKey: kCIInputImageKey)
        blur?.setValue(radius, forKey: kCIInputRadiusKey)
        
        if let ciImgWithBlurredRect = blur?.outputImage?.composited(over: ciImg),
           let outputImg = context.createCGImage(ciImgWithBlurredRect, from: ciImgWithBlurredRect.extent) {
            return UIImage(cgImage: outputImg)
        }
        return nil
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UICollectionView {
    func registerCollectionCell(identifier:String)  {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView {
    func registerTableCell(identifier:String)  {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}


extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        transform = transform.concatenating(CGAffineTransform(translationX: -(width / 2.3), y: 0))
    }
    
}



extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toPixels pixels: CGFloat, isOpaque: Bool = true) -> UIImage? {
        //        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = Float(pixels)
        let maxWidth: Float = Float(pixels)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        //            let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        debugPrint(actualWidth, actualHeight)
        
        let finalWidth = roundToClosestMultipleNumber(Int(actualWidth), 64) //Int(actualWidth)
        let finalHeight = roundToClosestMultipleNumber(Int(actualHeight), 64) //Int(actualHeight)
            
        let canvas = CGSize(width: CGFloat(finalWidth), height: CGFloat(finalHeight))
        
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func roundToClosestMultipleNumber(_ numberOne: Int, _ numberTwo: Int) -> Int {
        var result: Int = numberOne
        
        if numberOne % numberTwo != 0 {
            if numberOne < numberTwo {
                result = numberTwo
            } else {
                result = (numberOne / numberTwo + 1) * numberTwo
            }
        }
        
        return result
    }
    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
         DispatchQueue.global().async {
             if let data = try? Data(contentsOf: url) {
                 DispatchQueue.main.async {
                     completion(UIImage(data: data))
                 }
             } else {
                 DispatchQueue.main.async {
                     completion(nil)
                 }
             }
         }
     }
    
}


extension UITextView {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: self.bounds.width * 0.73, y: 12, width: 20, height: 20))
        iconView.image = image
        iconView.tag = 10001
        self.addSubview(iconView)
    }
    
    func removeIcon(){
        for subView in self.subviews{
            if subView.tag == 10001{
                subView.removeFromSuperview()
                break
            }
        }
    }
}

//MARK: UIViewController 
extension UIViewController{
    
    func showAlertWithAction(title:String?,message:String, action: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler:{ _ in
            action()
        }))
//        alert.addAction(.init(title: "cancel", style: .default, handler:nil)); self.present(alert, animated: true)
        self.present(alert, animated: true)
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let translationY = sender.translation(in: sender.view!).y

        switch sender.state {
        case .began:
            break
        case .changed:
            debugPrint("translationY ",translationY)
            if translationY > 0{
                view.transform = CGAffineTransform(translationX: 0, y: translationY)
            }
        case .ended, .cancelled:
            debugPrint("translationY ",translationY)
            if translationY > 160 {
                self.dismiss(animated: true, completion: nil)

            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        case .failed, .possible:
            break
        @unknown default:
            break
        }
    }
}
