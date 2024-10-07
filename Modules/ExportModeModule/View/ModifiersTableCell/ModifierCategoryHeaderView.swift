//
//  ModifierCategoryHeaderView.swift
//  DreamAI
//
//  Created by iApp on 29/11/22.
//

import UIKit

protocol SectionHeaderViewDelegate {
    //func sectionHeaderView(sectionHeaderView: ModifierCategoryHeaderView, sectionOpened: Int)
    //func sectionHeaderView(sectionHeaderView: ModifierCategoryHeaderView, sectionClosed: Int)
    
    func selectedSection(selIndex: Int)
}

class ModifierCategoryHeaderView: UITableViewHeaderFooterView {
    var delegate: SectionHeaderViewDelegate?

    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var headerViewButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func headerViewTapAction(_ sender: UIButton) {
        delegate?.selectedSection(selIndex: sender.tag)
        
    }
    
    func configureHeaderView(with modifierCategory: ModifierObject, section: Int){
        
        self.headerViewButton.tag = section
        self.headerViewButton.setTitle(modifierCategory.modifierCategory.title, for: .normal)
        
        if modifierCategory.isOpen{
            downArrowImageView.transform = CGAffineTransform(rotationAngle: 1.57)
        }else{
            downArrowImageView.transform = .identity
        }
        setUpFont()
    }
    
    private func setUpFont(){
        let fontSize13 = Font(.installed(.appRegular), size: .standard(.size13)).instance
        let attribute = headerViewButton.currentTitle?.attributedTo(font: fontSize13,spacing: 0.66,color: UIColor.appColor(.appTextUltraLightGray))
        headerViewButton.setAttributedTitle(attribute, for: .normal)
    }
}
