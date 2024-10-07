//
//  ThemeManager.swift
//  DreamAI
//
//  Created by iApp on 23/11/22.
//

import Foundation
import UIKit


enum AssetsColor: String {
    case appBackground
    case appDarkGray
    case appGray
    case appGreen
    case appGreenIAP
    case appBlueColor
    case appGrayBackground
    case appRed
    case appYellow
    
    
    // Text Colors
    case appTextTitleColor
    case appTextUltraLightGray
    case appTextPlaceholder //134,134,134,1
    case appTextGray
    case appTextLightGray //188,187,193,1
    case appTextMagenta
    case appTextYellow
   
    
    case bottomViewBgColor
    case textLightGray
    case appTextWhiteColor
    case txtViewBgColor
    case txtViewTitleColor
    case startImageBGColor // 37,36,41,1
    case startImageBorderColor
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
         return UIColor(named: name.rawValue)
    }
}

enum Theme: Int {
    case darkTheme, lightTheme
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {

    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .lightTheme
        }
    }

    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
    }
}
