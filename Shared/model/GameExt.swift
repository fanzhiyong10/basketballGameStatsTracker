//
//  GameExt.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/2.
//

import Foundation

extension Notification.Name {
    static let commandSuccess = Notification.Name("commandSuccess")
    static let toMake = Notification.Name("toMake") // ft_make_count
    static let toMiss = Notification.Name("toMiss") // ft_miss_count
    static let toBucket = Notification.Name("toBucket") // fg2_make_count
    static let toBrick = Notification.Name("toBrick") // fg2_miss_count
    static let toSwish = Notification.Name("toSwish") // fg3_make_count
    static let toOff = Notification.Name("toOff") // fg3_miss_count
    static let toDime = Notification.Name("toDime") // assts_count
    static let toBoard = Notification.Name("toBoard") // orebs_count
    static let toGlass = Notification.Name("toGlass") // drebs_count
    static let toSteal = Notification.Name("toSteal") // steals_count
    static let toBlock = Notification.Name("toBlock") // blocks_count
    static let toTie = Notification.Name("toTie") // ties_count
    static let toTip = Notification.Name("toTip") // defs_count
    static let toCharge = Notification.Name("toCharge") // charges_count
    static let toBad = Notification.Name("toBad") // tos_count
}

extension GameFromViewModel {
    /// 统计计算：ft_make_count
    @objc func toMake() {
//        footer_total.ft_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in self.playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ft_make_count
        }
        self.footer_total.ft_make_count = result
    }
    
    /// 统计计算：ft_miss_count
    @objc func toMiss() {
//        footer_total.ft_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ft_miss_count
        }
        footer_total.ft_miss_count = result
    }
    
    /// 统计计算：fg2_make_count
    @objc func toBucket() {
//        footer_total.fg2_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg2_make_count
        }
        footer_total.fg2_make_count = result
    }
    
    /// 统计计算：fg2_miss_count
    @objc func toBrick() {
//        footer_total.fg2_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg2_miss_count
        }
        footer_total.fg2_miss_count = result
    }
    
    /// 统计计算：fg3_make_count
    @objc func toSwish() {
//        footer_total.fg3_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg3_make_count
        }
        footer_total.fg3_make_count = result
    }
    
    /// 统计计算：fg3_miss_count
    @objc func toOff() {
//        footer_total.fg3_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg3_miss_count
        }
        footer_total.fg3_miss_count = result
    }
    
    /// 统计计算：orebs_count
    @objc func toBoard() {
//        footer_total.orebs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.orebs_count
        }
        footer_total.orebs_count = result
    }
    
    /// 统计计算：drebs_count
    @objc func toGlass() {
//        footer_total.drebs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.drebs_count
        }
        footer_total.drebs_count = result
    }
    
    /// 统计计算：assts_count
    @objc func toDime() {
//        footer_total.assts_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.assts_count
        }
        footer_total.assts_count = result
    }
    
    /// 统计计算：tos_count
    @objc func toBad() {
//        footer_total.tos_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.tos_count
        }
        footer_total.tos_count = result
    }
    
    /// 统计计算：steals_count
    @objc func toSteal() {
//        footer_total.steals_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.steals_count
        }
        footer_total.steals_count = result
    }
    
    /// 统计计算：blocks_count
    @objc func toBlock() {
//        footer_total.blocks_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.blocks_count
        }
        footer_total.blocks_count = result
    }
    
    /// 统计计算：defs_count
    @objc func toTip() {
//        footer_total.defs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.defs_count
        }
        footer_total.defs_count = result
    }
    
    /// 统计计算：charges_count
    @objc func toCharge() {
//        footer_total.charges_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.charges_count
        }
        footer_total.charges_count = result
    }
    
    /// 统计计算：ties_count
    @objc func toTie() {
//        footer_total.ties_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ties_count
        }
        footer_total.ties_count = result
    }
}
