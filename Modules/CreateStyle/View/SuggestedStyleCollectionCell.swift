//
//  SuggestedStyleCollectionCell.swift
//  DreamAI
//
//  Created by iApp on 07/11/22.
//

import UIKit
import SDWebImage

protocol SuggestedStyleDelegate: AnyObject{
    func didSelectIdeaOfTry(prompt: String, image: UIImage)
}

class SuggestedStyleCollectionCell: UICollectionViewCell {

    @IBOutlet weak var shadowImageView: UIImageView!
    weak var delegate: SuggestedStyleDelegate?
    @IBOutlet weak var styleTextLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    static let identifier = "SuggestedStyleCollectionCell"
    
    @IBOutlet weak var tryButton: UIButton!
    
    @IBOutlet weak var tryButtonWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    
    public func configureCell(with promptIdea: AIArtDataModel.PromptIdeasForAIArt, layoutType: ListPreview, cornerRadius:CGFloat = 10){
        
        let prompt = promptIdea.promptIdeas()
        let fontSize13 = Font(.installed(.appRegular), size: .standard(.size15)).instance
        let titleTextAttri = prompt.promptText.attributedTo(font: fontSize13, spacing: 0.60, color: .white)
        styleTextLabel.attributedText = titleTextAttri
        bgImageView.image = UIImage(named: prompt.imageName)
        
        let fontSize15 = Font(.installed(.appBold), size: .standard(.size15)).instance

        switch layoutType{
        case .grid:
            let tryTheseIdeaTitle = "Try".attributedTo(font: fontSize15, spacing: 0.75, color: .black)
            tryButton.setAttributedTitle(tryTheseIdeaTitle, for: .normal)
            tryButtonWidthConstraint.constant = 65
            styleTextLabel.numberOfLines = 2
        case .list:
            let tryTheseIdeaTitle = "Try this prompt".attributedTo(font: fontSize15, spacing: 0.75, color: .black)
            tryButton.setAttributedTitle(tryTheseIdeaTitle, for: .normal)
            tryButtonWidthConstraint.constant = 160
            styleTextLabel.numberOfLines = 0
        }
        self.corner(cornerRadius: cornerRadius)
    }
    
    public func configureCellForPreview(with promptImageName: String, cornerRadius:CGFloat = 10, byURL:Bool = false){
        if byURL{
            guard let _url = URL(string: promptImageName) else {return}
            bgImageView.sd_setImage(with: _url, placeholderImage: UIImage(named: "imgPlaceholder"))
        }else{
            bgImageView.image = UIImage(named: promptImageName)
        }
        self.corner(cornerRadius: cornerRadius)
    }
/*   public func configureCellForPreview(with promptIdea: AIArtDataModel.PromptIdeasForAIArt){
        let prompt = promptIdea.promptIdeas()
        bgImageView.image = UIImage(named: prompt.imageName)
        self.corner(cornerRadius: 10)
    }
    */
    
    @IBAction func tryButtonAction(_ sender: UIButton) {
        guard let prompt = styleTextLabel.text, let image = bgImageView.image else {return}
        
        delegate?.didSelectIdeaOfTry(prompt: prompt, image: image)
    }
    private func setupUI(){
        bgImageView.layer.cornerRadius = 2
        bgImageView.layer.masksToBounds = true
        shadowImageView.layer.cornerRadius = 2
        shadowImageView.layer.masksToBounds = true
        tryButton.layer.cornerRadius = 2//tryButton.bounds.height/2
        tryButton.layer.masksToBounds = true
    }
}
