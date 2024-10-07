//
//  PromptHistoryTableCell.swift
//  DreamAI
//
//  Created by iApp on 24/11/22.
//

import UIKit

class PromptHistoryTableCell: UITableViewCell {
    static let cellIdentifier = "PromptHistoryTableCell"
    @IBOutlet weak var promptTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUIFont(){
        let titleFont = Font(.installed(.myRiadRegular), size: .standard(.size13)).instance
        let titleAttribute = promptTextLabel.text?.attributedTo(font: titleFont, spacing: 0.67,lineSpacing: 8, color: UIColor.appColor(.appTextWhiteColor),alignment: .left)
        promptTextLabel.attributedText = titleAttribute
    }
    
    func configureCell(with promptDataModel: PromptDataModel){
        self.promptTextLabel.text = promptDataModel.prompt
        setupUIFont()
    }
    
}
