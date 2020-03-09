//
//  ArrayExtension.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import DTCoreText

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
     public func returnAttributedStringForHTMLString (fontFamily: String, fontName: String, fontSize: CGFloat, textColor: UIColor, textAlignment: CTTextAlignment) -> NSMutableAttributedString {
           let encodedData = self.data(using: String.Encoding.utf8)!
           let options = [
               DTDefaultFontFamily:fontFamily,
               DTDefaultFontName: fontName,
               DTDefaultFontSize: fontSize,
               DTDefaultTextColor: textColor,
               DTDefaultTextAlignment: NSNumber(value: textAlignment.rawValue)
               ] as [String : Any]
           let builder = DTHTMLAttributedStringBuilder(html: encodedData, options: options, documentAttributes: nil)
           var returnValue:NSAttributedString?
           returnValue = builder?.generatedAttributedString()
           if returnValue != nil {
               //needed to show link highlighting
               let mutable = NSMutableAttributedString(attributedString: returnValue!)
               mutable.removeAttribute(NSAttributedString.Key.foregroundColor, range: NSMakeRange(0, mutable.length))
               return mutable
           }else{
               return NSMutableAttributedString(string: "")
           }
       }
}
extension UIColor {

    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }

}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: .bottom, animated: true)
        }
    }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
