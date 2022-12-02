//
//  MainStateControl.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/15.
//

import Foundation

///全局变量
class MainStateControl: ObservableObject {
    // 删除：PlusMinus，缺省为+1，true
    @Published var isOnPlusMinus = true
    
    var value: Int {
        if isOnPlusMinus {
            print("isOn == true")
            return 1
        } else {
            print("isOn == false")
            return -1
        }
    }
    
    // 删除：按钮：声控，缺省为false
    @Published var isOnVoiceControl = false
    
    // 删除：按钮：大表显示，缺省为false，不显示
    @Published var isOnZoomin = false
    
    // 删除：按钮：上场队员替换显示，缺省为false，不显示
    @Published var isOnPlayers = false
    
    // 删除：按钮：手动输入显示，缺省为false，不显示
    @Published var isOnManualCommand = false
    
    
    //删除：MARK: - 比赛进行了多长时间，计数器
    @Published var game_cum_duration: Float = 0 // 23 * 60 + 45
    
    // 删除：正在比赛的小节
    @Published var periond_playing: Int = 0
    
    // 删除：选中高亮的小节
    @Published var periond_highlight: [Int] = [0]
    
    // 保留：比赛实时数据跟踪页面的状态
    @Published var trackerPageStatus = TrackerPageStatus.EnterTracker //First
    
    //删除：MARK: - 控制按钮的显示：START、STOP
//    @Published var started = false
}

/// 比赛实时数据跟踪页面的状态
enum TrackerPageStatus {
    case First // 第一个页面，出现按钮：选择球队
//    case SelectTeams // 选择球队
//    case SelectPlayers // 选择球员
    case EnterTracker // 跟踪页面：尚未点击start按钮
//    case Tracking // 第一次 点击 start 后，开始跟踪
//    case End // 跟踪结束
}
