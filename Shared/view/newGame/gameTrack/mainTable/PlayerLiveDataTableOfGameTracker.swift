//
//  PlayerLiveDataTableOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//


import SwiftUI

///队员数据表
///
///表格形式
///- header：静态数据
///- row：动态数据，可以修改
///- footer：统计：动态数据，可以修改
///
///
///队员的实时比赛数据
///- 1）必须确保传入
///- 2）数据可以修改，
///- 3）队员的实时比赛数据的变化，会引起统计数据的变化。
///
///数据技巧
///- 比赛：gameFromViewModel
///- 球员：gameFromViewModel.playerLiveDataFromViewModels
///- 变化同步显示：gameFromViewModel.counter_tap
struct PlayerLiveDataTableOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    var body: some View {
        // 列表：竖向
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    ForEach(gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.indices, id:\.self) { index in //.self
                        // 队员的实时比赛数据：数据变化与数据显示同步，响应要很快
                        PlayerLiveDataRowOfGameTracker(gameFromViewModel: gameFromViewModel, playerLiveDataFromViewModel: gameFromViewModel.perionds_highlight.count == 1 ? gameFromViewModel.periodDataOfMyTeamFromViewModels[gameFromViewModel.perionds_highlight.first! ].playerLiveDataFromViewModels[index] : gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index])
                            .frame(height: 60) // 行高
                            .listRowSeparator(.hidden) // 行分割线：隐藏
                            .background { // 行背景色
                                if index % 2 == 0 {
                                    Color.gray.opacity(0.3)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
//                            .listRowInsets(EdgeInsets()) // 左侧不留空间
                    }
                } header: { // 表头
                    PlayerLiveDataHeader(height: 40) // 40
                        
                } footer: { // 表尾
                    // 关键：统计数据，依赖于计算。队员的实时比赛数据的变化，会引起统计数据的变化
                    PlayerLiveDataFooterOfGameTracker(gameFromViewModel: gameFromViewModel)
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)) // leading 8

            }
            .overlay(alignment: .bottomLeading) {
                // 底部统计：状态变化：显示马上更新：GameFromViewModel 中的 counter_tap，与表尾同步
                PlayerLiveDataFooterOfGameTracker(gameFromViewModel: gameFromViewModel)
                    .padding(.leading, 8.0)
            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
        }
    }
}

struct PlayerLiveDataTableOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataTableOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
