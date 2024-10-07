//
//  StoreViewModel.swift
//  DreamAI
//
//  Created by iApp on 02/12/22.
//

import Foundation
import AVFoundation
import UIKit

enum ProductType {
    case weekly
    case monthly
    case yearly
    
    var productKey : String{
        switch self {

        } 
    }
//    meme@app3   .com
//    Welcome321#
}

class StoreViewModel: NSObject{
    
    
    private var productModels: [ProductModel]? {
        StoreManager.shared.products
    }
    
    var weeklyCutPrice: NSAttributedString {
        getCutPrice(.weekly)
    }
    
    var monthlyCutPrice: NSAttributedString{
        getCutPrice(.monthly)
    }
    
    var yearlyCutPrice: NSAttributedString{
        getCutPrice(.yearly)
    }
    
    var yearlyOriginalPrice: NSAttributedString{
        getCutPrice(.yearly,isOriginalPrice: true)
    }
    
    var weeklyPrice: String = "$2.99"
    
   private var currentProductType = ProductType.yearly
    
}

extension StoreViewModel {
    
    func didSelectProduct(product: ProductType){
        self.currentProductType = product
        
    }
    
    func purchaseProduct(complition: @escaping((Bool)->())) {
        
        StoreManager.shared.purchaseProduct(productType: self.currentProductType, complition: complition)
    }
    
    func restorePurchase(completion: @escaping((Bool, String)->())) {
        StoreManager.shared.restorePurchase(complition: completion)
    }
}


extension StoreViewModel{
    private func getCutPrice(_ type: ProductType, isOriginalPrice:Bool = false) -> NSAttributedString {
        guard let product = self.productModels?.filter({$0.productId == type.productKey}).first else {
            return NSMutableAttributedString()
        }
        guard let code = StoreManager.shared.currentLocaleSign?.first  else {
            return NSMutableAttributedString()
        }
        guard let decimalPrice = product.decimalPrice else {
            return NSMutableAttributedString()
        }
        var text = ""
        switch type {
        case .weekly:
            let price = decimalPrice
            let priceWithCode = "\(code)\(price.roundNumber(to: 2))"
            weeklyPrice = priceWithCode
            text =  "Weekly\n\(priceWithCode)/week"  //"Then: \(code)\(price.roundNumber(to: 2)) / week"
           
        case .monthly:
            let price = decimalPrice
            let priceWithCode = "\(code)\(price.roundNumber(to: 2))"
            text =  "Monthly\n\(priceWithCode)/month"
            
            break
        case .yearly:
            if isOriginalPrice{
                let price = decimalPrice
                let priceWithCode = "\(code)\(price.roundNumber(to: 2))"
                text =  "3 days free, then \(priceWithCode)/yearly"
                
                let padaukRegular = Font(.installed(.PadaukRegular), size: .standard(.size15)).instance
                let priceOfProduct = text.attributedTo(font: padaukRegular, spacing: 0.15, color: UIColor.appColor(.appTextPlaceholder),alignment: .left)
                
                return priceOfProduct
            }else{
                let price = decimalPrice / 52
                let priceWithCode = "\(code)\(price.roundNumber(to: 2))"
                text =  "Yearly\n\(priceWithCode)/week"
            }
            
            break
        }
        
        let padaukRegular = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
        let priceOfProduct = text.attributedTo(font: padaukRegular, spacing: 0.2, color: .white,alignment: .left)
        
        return priceOfProduct
        
    }
}

//MARK:- CGFloat
extension CGFloat{
static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    func roundNumber(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
