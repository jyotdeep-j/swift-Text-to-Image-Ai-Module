//
//  ModifiersTableCell.swift
//  DreamAI
//
//  Created by iApp on 29/11/22.
//

import UIKit

class ModifiersTableCell: UITableViewCell {

    static let identifier = "ModifiersTableCell"
    @IBOutlet weak var radioIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    var isRowSelected: Bool = false{
        didSet{
            let color = isRowSelected ? UIColor.appColor(.appBlueColor) : UIColor.appColor(.appTextLightGray)
            if let attributeString = titleLabel.attributedText as? NSMutableAttributedString{
                let range = NSMakeRange(0, attributeString.string.count)
                attributeString.addAttribute(.foregroundColor, value: color! , range: range)
                titleLabel.attributedText = attributeString
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with modifier: String) {
        radioIconImageView.isHidden = false
        self.titleLabel.text = modifier
        let fontSize13 = Font(.installed(.appRegular), size: .standard(.h5)).instance
        titleLabel.attributedText = titleLabel.text?.attributedTo(font: fontSize13,spacing: 0.58,color: UIColor.appColor(.appTextUltraLightGray))
    }
   
    func configureCell(withStableEngine engine: String, color: AssetsColor){
        radioIconImageView.isHidden = true
//        self.titleLabel.text = engine
        
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        titleLabel.attributedText = engine.attributedTo(font: fontSize18,spacing: 0,color: UIColor.appColor(color),alignment: .left)
    }
    
    func configureCell(withStableEngine engine: AIArtDataModel.AIStabileEngine, color: AssetsColor){
        radioIconImageView.isHidden = true
        
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
       if engine == .inpainting_v1_0 || engine == .inpainting_512_v2_0{
            
           let title = engine.engine().title.attributedTo(font: fontSize18,spacing: 0,color: UIColor.appColor(color),alignment: .left)
           let fontSize15 = Font(.installed(.PadaukRegular), size: .standard(.size15)).instance

           let commingSoon = " (Comming Soon)".attributedTo(font: fontSize15,spacing: 0,color: UIColor.appColor(color),alignment: .left)
           title.append(commingSoon)
           
           titleLabel.attributedText = title
       }else{
           titleLabel.attributedText = engine.engine().title.attributedTo(font: fontSize18,spacing: 0.58,color: UIColor.appColor(color),alignment: .left)

       }
    }
   
    
    
    
}
