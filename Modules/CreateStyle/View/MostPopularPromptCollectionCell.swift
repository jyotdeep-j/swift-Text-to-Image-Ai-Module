//
//  MostPopularPromptCollectionCell.swift
//  DreamAI
//
//  Created by iApp on 13/12/22.
//

import UIKit

class MostPopularPromptCollectionCell: UICollectionViewCell {

    @IBOutlet weak var promptTextLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backgroundContainerView: UIView!
    static let identifier = "MostPopularPromptCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        backgroundContainerView.layer.cornerRadius =  self.bounds.height/2
//        backgroundContainerView.layer.borderColor = UIColor.appColor(.appDarkGray)?.cgColor
//        backgroundContainerView.layer.borderWidth = 1
//        backgroundContainerView.layer.masksToBounds = true
    }
    
    func configureCell(popularPrompt: AIArtDataModel.MostPopularPrompt, currentSelectedPrompt: AIArtDataModel.MostPopularPrompt?){
        
        
        let detail = popularPrompt.styleDetail()
        
        iconImageView.image = UIImage(named: detail.imageName)
        promptTextLabel.text = detail.prompt
        
        backgroundContainerView.layer.cornerRadius =  self.bounds.height/2
        backgroundContainerView.layer.borderWidth = 1
        backgroundContainerView.layer.masksToBounds = true
        self.blurViewEffect(withAlpha: 0.75,cornerRadius: self.bounds.height/2)
        if popularPrompt == currentSelectedPrompt{
            backgroundContainerView.layer.borderColor = UIColor.appColor(.appBlueColor)?.cgColor
        }else{
            backgroundContainerView.layer.borderColor = UIColor.appColor(.appDarkGray)?.cgColor
        }
    }
}
