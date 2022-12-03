//
//  PlayerLiveDataRowOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI
import Speech

/// 球员实时数据跟踪表：一个球员数据
///
///入参
///1. @ObservedObject var gameFromViewModel: GameFromViewModel，比赛
///2. @ObservedObject var playerLiveDataFromViewModel: PlayerLiveDataFromViewModel，球员数据
///
/// 数据操作
/// - 点击，可对数据进行＋或者－
/// - 变化同步显示，控制变量counter_tap：self.gameFromViewModel.counter_tap += 1
struct PlayerLiveDataRowOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    //@ObservedObject，调用时，直接init
    @ObservedObject var gameFromViewModel: GameFromViewModel // @ObservedObject 数据修改，变化则显示
    @ObservedObject var playerLiveDataFromViewModel: PlayerLiveDataFromViewModel
    
    var height: CGFloat = 60
    
    
    let delta = calDeltaPercent()
    
    var body: some View {
        let columnWidths = calColumnWidths()
        let fontBig_size = CGFloat(22) - delta * 5.0

        let fontMiddle_size = CGFloat(20) - delta * 5.0
        let fontMakeMiss_size = CGFloat(20) - delta * 5.0
        let fontName_size = CGFloat(16) - delta * 5.0
        let fontNameBig_size = CGFloat(20) - delta * 5.0

        // 需要设定spacing: 0，缺省不为0
        HStack(alignment: .center, spacing: 0) {
            // nil检测
            Text(playerLiveDataFromViewModel.player)
                .frame(width: columnWidths[0], alignment: .center) // 列宽
                .overlay(alignment: .trailing) {
                    // 分隔符：列
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .font(playerLiveDataFromViewModel.isOnCourt == true ? Font.system(size: fontNameBig_size, weight: .bold) : Font.system(size: fontName_size))
                .foregroundColor(playerLiveDataFromViewModel.isOnCourt == true ? Color.green : nil)

            Text(playerLiveDataFromViewModel.number)
                .frame(width: columnWidths[1], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(playerLiveDataFromViewModel.minutes)
                .frame(width: columnWidths[2], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
//                .onReceive(NotificationCenter.default.publisher(for: .time_count)) { _ in
//                    // 会造成重复计算，因此去掉
//                    if playerLiveDataFromViewModel.isOnCourt {
//                        // 变化会马上显示
//                        playerLiveDataFromViewModel.time_cumulative += 1
//                    }
//                }
            

            Text(playerLiveDataFromViewModel.per)
                .frame(width: columnWidths[3], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // HStack最多有10个，因此需要再分组，使用HStack
            HStack(alignment: .center, spacing: 0) { // 4 - 7
                Text(playerLiveDataFromViewModel.points)
                    .frame(width: columnWidths[4], alignment: .center)
                    .font(.system(size: fontMiddle_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(playerLiveDataFromViewModel.ft)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[5], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                                self.liveData.ft_make_count += self.plus_minus
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.ft_make_count
                                let result = playerLiveDataFromViewModel.ft_make_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.ft_make_count = result >= 0 ? result : 0
                                
                                // 状态变化：马上显示
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toMake
//                                NotificationCenter.default.post(name: .toMake, object: self)
                                
                                // 同步更新：表尾统计数据
                                // 要点：索引
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.ft_make_count += playerLiveDataFromViewModel.ft_make_count - old
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                                self.liveData.ft_miss_count += self.plus_minus
//                            }
                        
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.ft_miss_count
                                let result = playerLiveDataFromViewModel.ft_miss_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.ft_miss_count = result >= 0 ? result : 0
                                
                                // 状态变化
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toMiss
//                                NotificationCenter.default.post(name: .toMiss, object: self)
                                
                                // 更新表尾统计数据
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.ft_miss_count += playerLiveDataFromViewModel.ft_miss_count - old
                                
                                // 提示声音
                                self.playSound()
                            }
                    }


                Text(playerLiveDataFromViewModel.fg2)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[6], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.fg2_make_count
                                let result = playerLiveDataFromViewModel.fg2_make_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.fg2_make_count = result >= 0 ? result : 0
                                
                                // 状态变化
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toBucket
//                                NotificationCenter.default.post(name: .toBucket, object: self)
                                
                                // 更新表尾统计数据
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.fg2_make_count += playerLiveDataFromViewModel.fg2_make_count - old
                                
                                // 提示声音
                                self.playSound()
                            }

                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                            }
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.fg2_miss_count
                                let result = playerLiveDataFromViewModel.fg2_miss_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.fg2_miss_count = result >= 0 ? result : 0
                                
                                // 状态变化
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toBrick
//                                NotificationCenter.default.post(name: .toBrick, object: self)
                                
                                // 更新表尾统计数据
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.fg2_miss_count += playerLiveDataFromViewModel.fg2_miss_count - old
                                
                                // 提示声音
                                self.playSound()
                            }
                    }

     
                Text(playerLiveDataFromViewModel.fg3)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[7], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.fg3_make_count
                                let result = playerLiveDataFromViewModel.fg3_make_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.fg3_make_count = result >= 0 ? result : 0
                                
                                // 状态变化
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toSwish
//                                NotificationCenter.default.post(name: .toSwish, object: self)
                                
                                // 更新表尾统计数据
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.fg3_make_count += playerLiveDataFromViewModel.fg3_make_count - old
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                            }
                        
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                // 入口保护条件
                                if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                                    // 比赛尚未开始
                                    // 请点击按钮 START，开始比赛
                                    gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                                    return
                                }
                                
                                if gameFromViewModel.perionds_highlight.count >= 2 {
                                    // 选中多个小节，不能修改数据
                                    gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                                    return
                                }
                                
                                // 算法：最小为0
                                let old = playerLiveDataFromViewModel.fg3_miss_count
                                let result = playerLiveDataFromViewModel.fg3_miss_count + self.gameFromViewModel.value
                                playerLiveDataFromViewModel.fg3_miss_count = result >= 0 ? result : 0
                                
                                // 状态变化
//                                self.gameFromViewModel.counter_tap += 1
                                
                                // 发出通知 toOff
//                                NotificationCenter.default.post(name: .toOff, object: self)
                                
                                // 更新表尾统计数据
                                gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.fg3_miss_count += playerLiveDataFromViewModel.fg3_miss_count - old
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
            }
            

            Text(playerLiveDataFromViewModel.eFG)
                .frame(width: columnWidths[8], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                

            HStack(alignment: .center, spacing: 0) {
                Text(playerLiveDataFromViewModel.assts)
                    .frame(width: columnWidths[9], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 点击：数据进行＋或者－，最小值为0
                        let old = playerLiveDataFromViewModel.assts_count
                        let result = playerLiveDataFromViewModel.assts_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.assts_count = result >= 0 ? result : 0
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.assts_count += playerLiveDataFromViewModel.assts_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.orebs)
                    .frame(width: columnWidths[10], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.orebs_count
                        let result = playerLiveDataFromViewModel.orebs_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.orebs_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toBoard
//                        NotificationCenter.default.post(name: .toBoard, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.orebs_count += playerLiveDataFromViewModel.orebs_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.drebs)
                    .frame(width: columnWidths[11], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.drebs_count
                        let result = playerLiveDataFromViewModel.drebs_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.drebs_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toGlass
//                        NotificationCenter.default.post(name: .toGlass, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.drebs_count += playerLiveDataFromViewModel.drebs_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.steals)
                    .frame(width: columnWidths[12], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.steals_count
                        let result = playerLiveDataFromViewModel.steals_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.steals_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toSteal
//                        NotificationCenter.default.post(name: .toSteal, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.steals_count += playerLiveDataFromViewModel.steals_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.blocks)
                    .frame(width: columnWidths[13], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.blocks_count
                        let result = playerLiveDataFromViewModel.blocks_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.blocks_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toBlock
//                        NotificationCenter.default.post(name: .toBlock, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.blocks_count += playerLiveDataFromViewModel.blocks_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.ties)
                    .frame(width: columnWidths[14], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.ties_count
                        let result = playerLiveDataFromViewModel.ties_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.ties_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toTie
//                        NotificationCenter.default.post(name: .toTie, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.ties_count += playerLiveDataFromViewModel.ties_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.defs)
                    .frame(width: columnWidths[15], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.defs_count
                        let result = playerLiveDataFromViewModel.defs_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.defs_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toTip
//                        NotificationCenter.default.post(name: .toTip, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.defs_count += playerLiveDataFromViewModel.defs_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.charges)
                    .frame(width: columnWidths[16], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.charges_count
                        let result = playerLiveDataFromViewModel.charges_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.charges_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toCharge
//                        NotificationCenter.default.post(name: .toCharge, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.charges_count += playerLiveDataFromViewModel.charges_count - old
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(playerLiveDataFromViewModel.tos)
                    .frame(width: columnWidths[17], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .onTapGesture {
                        // 入口保护条件
                        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                            // 比赛尚未开始
                            // 请点击按钮 START，开始比赛
                            gameFromViewModel.tap_player_Alert_GameNotStart.toggle()
                            return
                        }
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            // 选中多个小节，不能修改数据
                            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
                            return
                        }
                        
                        // 算法：最小为0
                        let old = playerLiveDataFromViewModel.tos_count
                        let result = playerLiveDataFromViewModel.tos_count + self.gameFromViewModel.value
                        playerLiveDataFromViewModel.tos_count = result >= 0 ? result : 0
                        
                        // 状态变化
//                        self.gameFromViewModel.counter_tap += 1
                        
                        // 发出通知 toBad
//                        NotificationCenter.default.post(name: .toBad, object: self)
                        
                        // 更新表尾统计数据
                        gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].footer_total.tos_count += playerLiveDataFromViewModel.tos_count - old
                        
                        // 提示声音
                        self.playSound()
                    }
            }
            
        }
        
        
    }
    
//    func playSound(_ block: @escaping () -> ()) {
    func playSound() {
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback)

        if let URL = Bundle.main.url(forResource: "ding", withExtension: "wav") {
            print("ding.wav")
            let audioEngine = AVAudioEngine()
            let playerNode = AVAudioPlayerNode()
            
            // Attach the player node to the audio engine.
            audioEngine.attach(playerNode)
            
            // Connect the player node to the output node.
            if let file = try? AVAudioFile(forReading: URL) {
                print("file ding.wav")
                audioEngine.connect(playerNode,
                                    to: audioEngine.outputNode,
                                    format: file.processingFormat)
                print("file ding.wav file.fileFormat")
                //        Then schedule the audio file for full playback. The callback notifies your app when playback completes.
                playerNode.scheduleFile(file, at: nil,
                                        completionCallbackType: .dataPlayedBack) { _ in
                    print("file ding.wav end")
                    audioEngine.stop()
                    
                    // 启动声控
//                    self.startVoiceListening()
//                    block()
                }
                
                // Before you play the audio, start the engine.
                do {
                    try audioEngine.start()
                    playerNode.play()
                } catch {
                    /* Handle the error. */
                }
            }
        }
    }
}

/*
struct PlayerLiveDataRowOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataRowOfGameTracker(gameFromViewModel: GameFromViewModel(), index: 0)
    }
}
*/
