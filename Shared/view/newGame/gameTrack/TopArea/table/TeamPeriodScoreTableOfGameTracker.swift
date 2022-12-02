//
//  TeamPeriodScoreTableOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

/// 两队比赛中各个小节的得分
struct TeamPeriodScoreTableOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel

    var body: some View {
        let columnWidths = TeamPeriodScore.shared.calColumnWidths()
        
        VStack {
            List {
                Section {
                    ForEach(0...1, id:\.self) { index in
                        TeamPeriodScoreRowOfGameTracker(gameFromViewModel: gameFromViewModel, index: index, count_period: gameFromViewModel.ids_PeriodDataOfMyTeam.count)
                            .frame(height: 35) // 行高
                            .listRowSeparator(.hidden) // 行分割线：隐藏
                            .background { // 行背景色
                                if index % 2 == 0 {
                                    Color.gray.opacity(0.3)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
                    }
                } header: { // 表头
                    TeamPeriodScoreHeader()
                        .frame(height: 30) // 行高
                }
                // 行定位1/2：位置，需要设定2处
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            }
            .padding(.top, -10.0)
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
            .environment(\.defaultMinListRowHeight, 30) // 控制行高
            .environment(\.defaultMinListHeaderHeight, 30) // 控制表头高度
        }
        .overlay(alignment: .leading) {
            // 显示选中的小节，高亮框
            HStack(alignment: .top, spacing: 0) {
                Text("")
                    .frame(width: columnWidths[0], height: 102)
                
                Text("")
                    .frame(width: columnWidths[1], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(0) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[2], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(1) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[3], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(2) ? .red : .clear, width: 2)
                
                Text("")
                    .frame(width: columnWidths[4], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(3) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[5], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(4) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[6], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(5) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[7], height: 102)
                    .border(gameFromViewModel.periond_highlight.contains(6) ? .red : .clear, width: 2)
            }
            .padding(.top, 4)
        }
        .alert("小节", isPresented: $gameFromViewModel.tap_period, actions: {
            // 第一个按钮
            Button("结束当前小节，开始下一个小节", role: .destructive, action: {
                // 仅选中下一个小节
                gameFromViewModel.beginNextPeriod()
//                gameFromViewModel.periond_highlight = [gameFromViewModel.periodDataOfMyTeamFromViewModels.count]
            })
            
            // 第二个按钮
            Button("结束比赛", action: {
                
            })
            
            // 第三个按钮
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("刚才点击了小节")
        })
    }
    
    
    func createData() -> [[String]] {
        var myTeam = [String]()
        myTeam.append("My Team")
        for index in 1...8 {
            myTeam.append("\(index)")
        }
        

        var opponentTeam = [String]()
        opponentTeam.append("Opponent")
        for index in 1...8 {
            opponentTeam.append("\(index)")
        }

        return [myTeam, opponentTeam]
    }
}

struct TeamPeriodScoreTableOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        TeamPeriodScoreTableOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
