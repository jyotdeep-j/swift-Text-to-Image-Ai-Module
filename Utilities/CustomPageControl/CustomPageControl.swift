//
//  CustomPageControl.swift
//  DreamAI
//
//  Created by iApp on 03/01/23.
//

import UIKit

class CustomPageControl: UIPageControl {
    
    @IBInspectable var currentPageImage: UIImage?
    
    @IBInspectable var otherPagesImage: UIImage?
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }
    
    private func defaultConfigurationForiOS14AndAbove() {
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                setIndicatorImage(otherPagesImage, forPage: index)
            }
            
            // give the same color as "otherPagesImage" color.
//            pageIndicatorTintColor = .gray
            
            // give the same color as "currentPageImage" color.
            currentPageIndicatorTintColor = UIColor.appColor(.appBlueColor) //.red
           /* if let image = UIImage(named: "currentPageIndicator"){
                currentPageIndicatorTintColor = UIColor(patternImage: image) //.red
            }else{
                currentPageIndicatorTintColor = UIColor.appColor(.appBlueColor)
            }*/
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
             */
        }
    }
    
    private func updateDots() {
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            }
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView
            
            return view
        }
    }
}
