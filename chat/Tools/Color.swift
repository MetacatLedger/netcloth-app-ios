//
//  Color.swift
//  chat
//
//  Created by Grand on 2020/3/13.
//  Copyright © 2020 netcloth. All rights reserved.
//

import Foundation

class Color {
    
    static let app_nav_theme = "#465EFF"
    static let app_bg_color = "#FFFFFF"
    
    /// Session Cell
    static let black = "#041036"
    
    static let gray = "#ADAFBA"
    static let gray_bf = "#BFC2CC"
    static let gray_d8 = "#D8D8D8"
    static let gray_f5 = "#F5F7FA"
    static let gray_90 = "#909399"
    static let gray_62 = "#62636B"
    static let gray_f4 = "#F4F4F4"
    static let gray_f7 = "#F7F7F7"
    
    
    
    
    static let red = "#FF4141"
    static let blue = "#465EFF"
    static let yellow = "FEDA03"
    
    /// chat room
    static let room_bg = "#F5F5F5"

    /// Mask shadow
    static let shadow_Layer = "#465EFF"
    
    /// speV fill color
    static let mask_bottom_empty = "#EDEFF2"
    static let mask_bottom_fill = Color.black
}

class FontSize {
    static let normal: CGFloat = 17
    static let small: CGFloat = 14
    static let little: CGFloat = 12
    static let least: CGFloat = 9
}


//MARK:- Pubkey Color
let RelatePubkeyColor = ["#5ABB27",
                         "#FF4141",
                         "#009C63",
                         "#FF7436",
                         "#3EC6E8",
                         "#1EC8AF",
                         "#FF5A71",
                         "#465EFF",
                         "#FFCC23",
                         "#9965FF"]

let RelateDefaultColor = "#465EFF"

var RelateColorCache = [String: String]()
extension String {
    func randomColor() -> String {
        
        if let c = RelateColorCache[self] {
            return c
        }
        
        if let hexpubkey = OC_Chat_Plugin_Bridge.unCompressedHexStrPubkey(ofCompressHexPubkey: self) {
            let hex4 = hexpubkey.suffix(4)
            let n: Int = Int(hex4, radix: 16) ?? 0
            let m = n % RelatePubkeyColor.count
            let pkc = RelatePubkeyColor[m]
            
            RelateColorCache[self] = pkc
            //Todo remove
            
            return pkc
        }
        return RelateDefaultColor
    }
}
