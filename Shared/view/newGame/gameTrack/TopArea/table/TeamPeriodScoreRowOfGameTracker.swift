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

            // 第2小节
            Text(count_period >= 2 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[1].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[1].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第3小节
            Text(count_period >= 3 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[2].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[2].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第4小节
            Text(count_period >= 4 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[3].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[3].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第5小节：加时1
            Text(count_period >= 5 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[4].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[4].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第6小节：加时2
            Text(count_period >= 6 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[5].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[5].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // 第7小节：加时3
            Text(count_period >= 7 ? (index == 0 ? String(self.gameFromViewModel.periodDataOfMyTeamFromViewModels[6].score) : String(self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels[6].score)) : "-")
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
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
