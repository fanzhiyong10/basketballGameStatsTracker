//
//  TeamPeriodScoreTable.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/13.
//

import SwiftUI

struct TeamPeriodScoreTable: View {
    var body: some View {
        var liveDatas = createData()
        VStack {
            List {
                Section {
                    ForEach(0...liveDatas.count-1, id:\.self) { index in
                        TeamPeriodScoreRow(teamPeriodScores: liveDatas[index])
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

struct TeamPeriodScoreTable_Previews: PreviewProvider {
    static var previews: some View {
        TeamPeriodScoreTable()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
