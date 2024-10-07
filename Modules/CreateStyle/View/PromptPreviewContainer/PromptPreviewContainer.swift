//
//  PromptPreviewContainer.swift
//  DreamAI
//
//  Created by iApp on 13/12/22.
//

import UIKit

class PromptPreviewContainer: UIView {

    //MARK: Preview Layout Container Outlets
    @IBOutlet weak var promptPreviewContainer: UIView!
    @IBOutlet weak var promptPreviewImageView: UIImageView!
    @IBOutlet weak var tryThisPromptButton: UIButton!
    @IBOutlet weak var promptContainerView: UIView!
    @IBOutlet weak var closePromptPreviewButton: UIButton!
    @IBOutlet weak var promptPreviewShadowImageView: UIImageView!
    @IBOutlet weak var promptPreviewLabel: UILabel!
    
    
    weak var delegate: SuggestedStyleDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.setupUIFont()
    }

    
    private func setupUI(){
        promptContainerView.layer.cornerRadius = 3//15
        promptContainerView.layer.masksToBounds = true
        promptPreviewImageView.layer.cornerRadius = 2//10
        promptPreviewImageView.layer.masksToBounds = true
        tryThisPromptButton.layer.cornerRadius = 2//15
        tryThisPromptButton.layer.masksToBounds = true
        promptPreviewShadowImageView.layer.cornerRadius = 2//10
        promptPreviewShadowImageView.layer.masksToBounds = true
    }
    
    private func setupUIFont() {
        let fontSize15 = Font(.installed(.appBold), size: .standard(.size15)).instance
        let tryThisPromptTitle = tryThisPromptButton.currentTitle?.attributedTo(font: fontSize15, spacing: 0.75, color: .white)
        tryThisPromptButton.setAttributedTitle(tryThisPromptTitle, for: .normal)
    }
    
    
    func showPromptPreview(promptIdea: AIArtDataModel.PromptIdeasForAIArt){
        let prompt = promptIdea.promptIdeas()
        let fontSize13 = Font(.installed(.appRegular), size: .standard(.size15)).instance
        let titleTextAttri = prompt.promptText.attributedTo(font: fontSize13, spacing: 0.60, color: .white)
        promptPreviewLabel.attributedText = titleTextAttri
        self.promptPreviewImageView.image = UIImage(named: prompt.imageName)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.alpha = 1.0
        } completion: { isComplete in
        }
    }
    
    
    @IBAction func tryThisPromptAction(_ sender: UIButton) {
        
        guard let prompt = self.promptPreviewLabel.text, let image = promptPreviewImageView.image else {return}
        delegate?.didSelectIdeaOfTry(prompt: prompt, image: image)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0.0
        } completion: { isComplete in
        }
    }
    
    @IBAction func closePromptPreviewAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0.0
        } completion: { isComplete in
        }
    }
}


