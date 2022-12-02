//
//  LiveDataTableInfo.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/15.
//

import UIKit

// Header Words
let headerWords = ["PLAYER", "NUMBER", "MINUTES", "PER", "POINTS", "FT", "2FG", "3FG", "eFG%", "ASSTS", "OREBS", "DREBS", "STEALS", "BLOCKS", "TIES", "DEFS", "CHARGES", "TOS"]

let headerWordsPart1 = ["PLAYER", "NUMBER", "MINUTES", "PER", "POINTS", "FT Make", "FT Total", "FT Make %", "2FG Make", "2FG Total", "2FG Make %", "3FG Make", "3FG Total", "3FG Make %", "eFG%", "ASSTS", "OREBS", "DREBS", "STEALS", "BLOCKS", "TIES", "DEFS", "CHARGES", "TOS"]
let headerWordsPart2 = ["1pt make", "1pt miss", "1pt %", "2pt make", "2pt miss", "2pt %", "3pt make", "3pt miss", "3pt %"]

let headerCellColors: [UIColor] = [UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.systemYellow, UIColor.systemOrange, UIColor(displayP3Red: 1.0, green: 1.0, blue: 224.0/255, alpha: 1.0), UIColor(displayP3Red: 192.0/255, green: 192.0/255, blue: 192.0/255, alpha: 1.0), UIColor.black, UIColor.purple, UIColor.gray, UIColor.systemGreen, UIColor.systemRed]

let headerFontColors: [UIColor] = [UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.systemBlue, UIColor.systemBlue, UIColor.systemBlue, UIColor.systemBlue, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white]
