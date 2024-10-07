//
//  IAPImagePreviewCollectionCell.swift
//  DreamAI
//
//  Created by iApp on 01/12/22.
//

import UIKit

class IAPImagePreviewCollectionCell: UICollectionViewCell {

    static let identifier = "IAPImagePreviewCollectionCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(forProduct productName: String){
        productImageView.layer.cornerRadius = 0
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = UIImage(named: productName)
    }
    
    func configureCell(forStyle style: String){
        productImageView.image = UIImage(named: style)
        productImageView.layer.cornerRadius = 10
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.masksToBounds = true
    }
    
}
