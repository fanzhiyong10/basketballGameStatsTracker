//
//  TeamPeriodScoreRowOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

/// 两队各个小节的行
struct TeamPeriodScoreRowOfGameTracker: View {
    // 表格的数据计算
    let teamPeriodScore = TeamPeriodScore.shared
    
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    // 行索引：0为我队，1为对方球队
    var index: Int
    
    // 小节数量
    var count_period: Int
    
    init(gameFromViewModel: GameFromViewModel, index: Int, count_period: Int) {
        self.gameFromViewModel = gameFromViewModel
        self.index = index
        self.count_period = count_period
    }
    
    var body: some View {
        let columnWidths = teamPeriodScore.calColumnWidths()
        let height = teamPeriodScore.height_row
        
        HStack(alignment: .center, spacing: 0) {
            // 球队名称，index==0，我方；否则为对方
            Text(index == 0 ? self.gameFromViewModel.name_my_team : self.gameFromViewModel.name_opponent_team)
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[0], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第1小节
            Text(count_period >= 1 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[0].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[0].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("P1")
                    
                    // 逻辑
                    // 1. 如果当前小节正在比赛，则该小节P1始终亮，点击提示：1.1）下一个小节；1.2）终止比赛；1.3）取消
                    // 2. 如果有多个小节，说明小节1已结束，若在高亮，则去掉高亮；若不是，则选中高亮；并进行相应的统计计算。
                    gameFromViewModel.tap_period1.toggle()
                }

            // 第2小节
            Text(count_period >= 2 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[1].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[1].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("P2")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period2.toggle()
                }

            // 第3小节
            Text(count_period >= 3 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[2].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[2].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("P3")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period3.toggle()
                }

            // 第4小节
            Text(count_period >= 4 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[3].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[3].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("P4")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period4.toggle()
                }

            // 第5小节：加时1
            Text(count_period >= 5 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[4].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[4].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("O1")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period5.toggle()
                }

            // 第6小节：加时2
            Text(count_period >= 6 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[5].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[5].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("O2")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period6.toggle()
                }

            // 第7小节：加时3
            Text(count_period >= 7 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[6].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[6].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    print("O3")
                    
                    // 点击小节，需要给出响应
                    gameFromViewModel.tap_period7.toggle()
                }

            // 两队统计得分
            Text(index == 0 ? String(self.gameFromViewModel.score_MyTeam) : String(self.gameFromViewModel.score_OpponentTeam))
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[8], alignment: .center)

        }
    }
    
    
}

struct TeamPeriodScoreRowOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        TeamPeriodScoreRowOfGameTracker(gameFromViewModel: GameFromViewModel(), index: 0, count_period: 1)
    }
}
