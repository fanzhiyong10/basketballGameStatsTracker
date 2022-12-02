//
//  ShareStep.swift
//  basketballStatsTracker
//
//  Created by 范志勇 on 2022/10/15.
//

import Foundation
/*
enum ShareStep: Int {
    case Phase0 = 0
    case Phase1 = 1
    case Phase2 = 2
}
*/
enum InputValueStatus: Int {
    case Increase = 1 // 加1
    case Decrease = -1 // 减1
}

/// Period, OverTime（加时）
enum Period: Int {
    case Period1 = 1
    case Period2 = 2
    case Period3 = 3
    case Period4 = 4
    case O1 = 5
    case O2 = 6
    case O3 = 7
}

/// 小节状态
///
/// 初始状态说明
/// - 第一小节，初始状态为：IsPlayingOnDisplay
/// - 其他小节，初始状态为：NotStart
///
/// 状态切换：比赛中
/// - 点击第一小节（IsPlayingOnDisplay），第一小节变为EndOffDisplay，第二小节（NotStart）变为IsPlayingOnDisplay。依次顺序进行。
/// - 点击最后一个小节（IsPlayingOnDisplay），比赛结束。
/// - 点击在小节（NotStart），不起作用。
/// - 点击小节（EndOffDisplay）则变为EndOnDisplay，同时将小节（IsPlayingOnDisplay）变为IsPlayingOffDisplay。
/// - 点击小节（IsPlayingOffDisplay）则变为IsPlayingOnDisplay，同时将小节（EndOnDisplay）变为EndOffDisplay。
/// - 点击小节（EndOnDisplay），不起作用。
///
/// 状态切换：比赛结束后
/// - 点击第一小节（IsPlayingOnDisplay），第一小节变为EndOffDisplay，第二小节（NotStart）变为IsPlayingOnDisplay。依次顺序进行。
/// - 点击最后一个小节（IsPlayingOnDisplay），比赛结束。
/// - 点击在小节（NotStart），不起作用。
/// - 点击小节（EndOffDisplay）则变为EndOnDisplay，同时将小节（IsPlayingOnDisplay）变为IsPlayingOffDisplay。
/// - 点击小节（IsPlayingOffDisplay）则变为IsPlayingOnDisplay，同时将小节（EndOnDisplay）变为EndOffDisplay。
/// - 点击小节（EndOnDisplay），不起作用。
enum PeriodStatus: Int {
    case NotStart = 1
    case IsPlayingOnDisplay = 2
    case IsPlayingOffDisplay = 3
    case EndOnDisplay = 4
    case EndOffDisplay = 5
}

/// 比赛状态
///
/// 状态切换：不是End
/// - 点击start按钮，从NotStart变为IsPlaying
/// - 点击stop按钮，从IsPlaying变为IsPlayingOnPause
///
/// 状态切换：若是End，则点击start按钮，不起作用
enum GameStatus: Int {
    case NotStart = 1
    case IsPlaying = 2
    case IsPlayingOnPause = 3
    case End = 4
}
