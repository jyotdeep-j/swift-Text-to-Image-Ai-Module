//
//  ImageNumberColleactionCell.swift
//  DreamAI
//
//  Created by iApp on 28/12/22.
//

import UIKit

class ImageNumberColleactionCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgIconImageView: UIImageView!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var proIconImageView: UIImageView!
    static let identifier = "ImageNumberColleactionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(with numberOfImage: NumberOfOutputImages, currentCount: NumberOfOutputImages){
        let detail = numberOfImage.detail()
        let title = detail.title
        let iconName = detail.iconName
        if numberOfImage == currentCount{
            borderView.border(width: 1, color: .appBlueColor).corner(cornerRadius: 5)
            bgIconImageView.tintColor = UIColor.appColor(.appBlueColor)
        }else{
            bgIconImageView.tintColor = UIColor.appColor(.appGrayBackground)
            borderView.corner(cornerRadius: 5)
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        titleCountLabel.text = title
        if StoreManager.shared.isPurchased{
            proIconImageView.isHidden = true
        }else{
            proIconImageView.isHidden = !detail.isPro
        }
        
        bgIconImageView.image = UIImage(named: iconName)
        
        let fontSize18 = Font(.installed(.PadaukBold), size: .standard(.h3)).instance
        let titleTextAttri = titleCountLabel.text?.attributedTo(font: fontSize18, spacing: 0, color: .white,alignment: .center)
        titleCountLabel.attributedText = titleTextAttri
        
    }
}
