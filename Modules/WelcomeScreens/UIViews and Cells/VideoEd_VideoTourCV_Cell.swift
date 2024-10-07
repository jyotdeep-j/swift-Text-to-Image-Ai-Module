//
//  VideoEd_VideoTourCV_Cell.swift
//  VideoEditorial
//
//  Created by iApp on 22/10/20.
//  Copyright © 2020 iApp. All rights reserved.
//

import UIKit

class VideoEd_VideoTourCV_Cell: UICollectionViewCell {

    @IBOutlet weak var videoViewHeightConstraint        : NSLayoutConstraint!
    @IBOutlet weak var mainView                         : UIView!
    @IBOutlet weak var videoView                        : UIView!
    @IBOutlet weak var videoUpperView                   : UIView!
    @IBOutlet weak var firstTitleView                   : UIView!
    @IBOutlet weak var secondTitleView                  : UIView!
    @IBOutlet weak var backVideoThumbView               : UIImageView!
    @IBOutlet weak var firstTitleLbl                    : UILabel!
    @IBOutlet weak var secondTitleLbl                   : UILabel!
    @IBOutlet weak var descriptionLbl                   : UILabel!
    
    @IBOutlet weak var sampleImageView1                 : UIImageView!
    @IBOutlet weak var sampleImageView2                 : UIImageView!
    @IBOutlet weak var sampleImageView3                 : UIImageView!
    @IBOutlet weak var sampleImageView4                 : UIImageView!
    let gradientLayer                                   = CAGradientLayer()


    override func awakeFromNib() {
        super.awakeFromNib()
        backVideoThumbView.contentMode = .scaleAspectFill

        // Initialization code
        // setUpUI(frame: self.bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let parentViewHeight = 1774/1242 * self.frame.width
        videoViewHeightConstraint.constant = parentViewHeight
    }
    
    func setUpUI(frame:CGRect){
        DispatchQueue.main.async {
            debugPrint("setup UI frame :",frame)
            let height = 70
            let parentViewHeight = 1774/1242 * frame.width
            let frame = CGRect(x: 0, y: Int(parentViewHeight) - height + 5, width: Int(frame.width), height: height)
            self.gradientLayer.frame = frame
            self.gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//            if IS_IPHONE_X_Series || IS_IPHONE_X_MAX {
//                self.gradientLayer.locations = [0.0, 1.0]
//            }else if IS_IPHONE{
//                self.gradientLayer.locations = [0.0, 0.7]
//            }

            self.videoUpperView.layer.addSublayer(self.gradientLayer)
            self.videoViewHeightConstraint.constant = parentViewHeight
            self.layoutIfNeeded()
        }
    }
    
    
}
