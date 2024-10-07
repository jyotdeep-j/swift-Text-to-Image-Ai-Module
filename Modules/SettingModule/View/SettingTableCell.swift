//
//  SettingTableCell.swift
//  DreamAI
//
//  Created by iApp on 22/11/22.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    static let cellIdentifier = "SettingTableCell"
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBodderLineView: UIView!
    var setting: SettingType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        switch setting {
        case .emialSupport:
            cellBackgroundView.roundCorners(.allCorners, radius: 8)
        case .privacy:
            cellBackgroundView.roundCorners([.topLeft,.topRight], radius: 8)
        case .terms:
            cellBackgroundView.roundCorners([.bottomLeft,.bottomRight], radius: 8)
        case .howToCreateThePerfectPrompt:
            cellBackgroundView.roundCorners(.allCorners, radius: 8)
        case .darkLightTheme:
            let theme = ThemeManager.currentTheme()
            if theme == .lightTheme {
                overrideUserInterfaceStyle = .light
                switcher.isOn = false
            }else{
                overrideUserInterfaceStyle = .dark
                switcher.isOn = true
            }
        case .none:
            break
        case .some(_):
            break
        }
     
    }
    
    func configureCell(setting:SettingType, indexPath: IndexPath, totalCount: Int){
        self.setting = setting
        titleLabel.text = setting.title
        bottomBodderLineView.isHidden = false
        if indexPath.section == 0 && indexPath.item == 0{
            bottomBodderLineView.isHidden = true
            switcher.isHidden = true
            cellBackgroundView.roundCorners(.allCorners, radius: 8)
        }else if indexPath.section == 1 && indexPath.item == 0{
            switcher.isHidden = true
            cellBackgroundView.roundCorners([.topLeft,.topRight], radius: 8)
        }else if indexPath.section == 1 && indexPath.item == 1{
            switcher.isHidden = true
            cellBackgroundView.roundCorners([.topLeft,.topRight], radius: 8)
            bottomBodderLineView.isHidden = true
        }else if indexPath.section == 2 && indexPath.item == 0{
            bottomBodderLineView.isHidden = true
            switcher.isHidden = false
//            cellBackgroundView.roundCorners([.bottomLeft,.bottomRight], radius: 8)
            cellBackgroundView.roundCorners(.allCorners, radius: 8)
        }
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn{
            ThemeManager.applyTheme(theme: .darkTheme)
        }else{
            ThemeManager.applyTheme(theme: .lightTheme)
        }
        
    }
}
