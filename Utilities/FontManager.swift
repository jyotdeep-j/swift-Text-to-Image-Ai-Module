//
//  FontManager.swift
//  CartoonMe
//
//  Created by iApp on 22/07/22.
//

import Foundation
import UIKit
//import XCTest


//Reference :- https://medium.com/@sauvik_dolui/handling-fonts-in-ios-development-a-simpler-way-32d360cdc1b6

// Usage Examples
/* let system12            = Font(.system, size: .standard(.h5)).instance
let robotoThin20        = Font(.installed(.ChalkboardSEBold), size: .standard(.h1)).instance
let robotoBlack14       = Font(.installed(.ChalkboardSERegular), size: .standard(.h4)).instance
let helveticaLight13    = Font(.custom("Helvetica-Light"), size: .custom(13.0)).instance
*/

struct Font {

    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
        
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    enum FontName: String {
        case appBold = "Arial-BoldMT"
        case appRegular = "ArialMT"
        case myRiadRegular = "MyriadPro-Regular"
        case myRiadBold = "MyriadPro-Bold"
        case myRiadSemiBold = "MyriadPro-Semibold"
        case avianoFlareLight = "AvianoFlareLight"
        
        case PadaukRegular = "Padauk-Regular"
        case PadaukBold = "Padauk-Bold"
        
        case HelveticaBold = "Helvetica Neue Bold"
        case HelveticaRegular = "Helvetica Neue"
     /*
        case SfProBlack             =         "SFProDisplay-Black"
        case SfProBlackItalic       =         "SFProDisplay-BlackItalic"
        case SfProBold              =         "SFProDisplay-Bold"
        case SfProBoldItalic        =         "SFProDisplay-BoldItalic"
        case SfProHeavy             =         "SFProDisplay-Heavy"
        case SfproHeavyItalic       =         "SFProDisplay-HeavyItalic"
        case SfProLight             =         "SFProDisplay-Light"
        case SfProLightItalic       =         "SFProDisplay-LightItalic"
        case SfProMedium            =         "SFProDisplay-Medium"
        case SfProRegular           =         "SFProDisplay-Regular"
        case SfProRegularItalic     =         "SFProDisplay-RegularItalic"
        case SfProSemibold          =         "SFProDisplay-Semibold"
        case SfProSemiboldItalic    =         "SFProDisplay-SemiboldItalic"
        case SfProThin              =         "SFProDisplay-Thin"*/
    }
    
    
    enum StandardSize: Double {
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.67//16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
        case size32 = 32.0
        case size26 = 26.0
        case size25 = 25.0

        case size23 = 23.0
        case size13 = 13.3
        case size15 = 15.0
        
    }

    
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Double{
    var propotionalSize: CGFloat {
        if Devices.IS_IPHONE_X {
            return self
        } else if Devices.IS_IPHONE_X_AND_MORE {
            return self + 1
        } else if Devices.IS_IPHONE_6_8P {
            return self - 1
            
        } else if Devices.IS_IPHONE_6_8 {
            return self - 2
        } else if Devices.IS_IPAD {
            return self + 4
        } else  {
            return self - 3
        }
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Helper.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Helper.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: weight))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}


