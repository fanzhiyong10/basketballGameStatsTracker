//
//  OpponentScoreStepperOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

/// 对方计分
///
/// 计分
/// - 步进器：Stepper
///
/// 数据传入传出
/// - @ObservedObject var gameFromViewModel: GameFromViewModel
///
/// 生命周期的逻辑说明（不同于UIKit）
/// 1. 第一次生成
/// 1.1. 显示值：
/// 1.2. 点击步进器的 + 或则 -，绑定值（Binding）发生变化，导致重新生成
/// 2. 重新生成OpponentScoreStepperOfGameTracker，显示值使用变化后的值
struct OpponentScoreStepperOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel

    init(gameFromViewModel: GameFromViewModel) {
        self.gameFromViewModel = gameFromViewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            // 1. 显示值
            Text("\((gameFromViewModel.periodDataOfOpponentTeamFromViewModels.last?.score)!)")
                .frame(width: 80, height: 48, alignment: .center)
                .font(.system(size: 28))
                .background {
                    Color.white
                }
                .border(.green, width: 2)
            
            // 2. 步进器：入参（变化值）：$gameFromViewModel.periodDataOfOpponentTeamFromViewModels.last!.score
            Stepper("", value: $gameFromViewModel.periodDataOfOpponentTeamFromViewModels.last!.score, in: 0...200, step: 1)
                .frame(width: 85, height: 40, alignment: .center)
                
        }
        .frame(width: 90, height: 120, alignment: .center)
    }
}

struct OpponentScoreStepperOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        // 入参：gameFromViewModel: GameFromViewModel()
        OpponentScoreStepperOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
