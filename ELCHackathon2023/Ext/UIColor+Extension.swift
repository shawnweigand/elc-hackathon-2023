//
//  UIColor+Extension.swift
//  ELCHackathon2023
//
//  Created by Macbook on 3/17/23.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        var hexValue: UInt64 = 0
        if scanner.scanHexInt64(&hexValue) {
            let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(hexValue & 0x0000FF) / 255.0

            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            self.init()
        }
    }
}
