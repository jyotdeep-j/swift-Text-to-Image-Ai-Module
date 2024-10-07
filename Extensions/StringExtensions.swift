//
//  StringExtensions.swift
//  CartoonMe
//
//  Created by iApp on 25/07/22.
//

import UIKit

extension String {
    func attributedTo(font: UIFont,spacing:CGFloat = 0.0, lineSpacing: CGFloat = 0 ,color: UIColor? = nil, alignment: NSTextAlignment = .left, lineBrackMode: NSLineBreakMode = .byWordWrapping) -> NSMutableAttributedString{
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        paraStyle.lineBreakMode = lineBrackMode
        let range = NSMakeRange(0, self.count)
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(.font, value: font, range: range)
        attrStr.addAttribute(.kern, value: spacing, range: range)
        attrStr.addAttribute(.paragraphStyle, value: paraStyle, range: range)
        //        NSAttributedString.Key.paragraphStyle: paraStyle,
        if let textColor = color {
            attrStr.addAttribute(.foregroundColor, value: textColor, range: range)
        }
        return attrStr
    }
    
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func truncate(to limit: Int, ellipsis: Bool = true) -> String {
        if count > limit {
            let truncated = String(prefix(limit)).trimmingCharacters(in: .whitespacesAndNewlines)
            return ellipsis ? truncated + "\u{2026}" : truncated
        } else {
            return self
        }
    }
    
}


extension NSMutableAttributedString{
    
    func underline(_ value: CGFloat) -> NSMutableAttributedString{
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: self.length));
        return self
    }
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//           let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        let boundingBox = self.boundingRect(with: constraintRect,options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
           return boundingBox.height
       }
    
    
}
/*extension String{
    func widthWithConstrained(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height:height )
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
*/
