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
                        TeamPeriodScoreRowOfGameTracker(gameFromViewModel: gameFromViewModel, index: index, count_period: gameFromViewModel.periodDataOfMyTeamFromViewModels.count)
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
            // 控制显示，集合中是否包含：gameFromViewModel.periond_highlight.contains(1)
            HStack(alignment: .top, spacing: 0) {
                Text("")
                    .frame(width: columnWidths[0], height: 102)
                
                Text("")
                    .frame(width: columnWidths[1], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(0) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[2], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(1) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[3], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(2) ? .red : .clear, width: 2)
                
                Text("")
                    .frame(width: columnWidths[4], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(3) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[5], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(4) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[6], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(5) ? .red : .clear, width: 2)

                Text("")
                    .frame(width: columnWidths[7], height: 102)
                    .border(gameFromViewModel.perionds_highlight.contains(6) ? .red : .clear, width: 2)
            }
            .padding(.top, 4) // 顶部对齐：与表的顶部对齐
        }
        .alert("P1 tapped", isPresented: $gameFromViewModel.tap_period1, actions: {
            // 区分P1是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P1是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 1 { // P1：比赛中
                    // P1：比赛中
                    // 第一个按钮：结束P1，开始P2
                    Button("Stop P1，Start P2", role: .destructive, action: {
                        // 开始下一个小节：P2
                        gameFromViewModel.beginNextPeriod()
                    })
                    
                    // 第二个按钮：结束比赛
                    Button("Game Over", action: {
                        gameFromViewModel.status_Game = 2 // 比赛结束
                    })
                } else { // P1已经比赛结束，但比赛尚未结束
                    //P1已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [0] {
                        // P1已经高亮，再次点击
                    } else {
                        Button("View P1", role: .destructive, action: {
                            // P1不是高亮，切换到小节：P1
                            gameFromViewModel.perionds_highlight = [0]
                        })
                    }
                    
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分P1是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(0) {
                    // 包含，改为：不选
                    
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select P1", action: {
                            gameFromViewModel.perionds_highlight.remove(0)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select P1", action: {
                        gameFromViewModel.perionds_highlight.insert(0)
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            gameFromViewModel.processMultiSelectPeriod()
                        }
                    })
                }
            }
            
            // 按钮Cancel，处理：比赛未开始，则不显示
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            } else {
                // 按钮：Cancel
                Button("Cancel", role: .cancel, action: {})
            }
        }, message: {
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                Text("Game has not started yet, \nPlease click \"Start\" button to start game")
            } else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P1是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 1 { // P1：比赛中
                    // P1：比赛中
                    Text("P1 is playing")
                } else { // P1已经比赛结束，但比赛尚未结束
                    //P1已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [0] {
                        // P1已经高亮，再次点击
                        Text("You're Viewing P1")
                    } else {
                        Text("P1 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
            
        })
        .alert("P2 tapped", isPresented: $gameFromViewModel.tap_period2, actions: {
            // 区分P2是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P2是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 2 { // P2 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 2 { // P2：比赛中，比赛中的小节为数组中最后的小节
                    // P2：比赛中，两种情况
                    // 如果当前的高亮小节是P2，则有2个按钮。
                    // 如果当前的高亮小节不是P2，则返回到P2，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [1] {
                        // 如果当前的高亮小节是P2，则有2个按钮。
                        // 第一个按钮：结束P2，开始P3
                        Button("Stop P2，Start P3", role: .destructive, action: {
                            // 开始下一个小节：P3
                            gameFromViewModel.beginNextPeriod()
                        })
                        
                        // 第二个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to P2 Playing", role: .destructive, action: {
                            // 切换到小节：P2
                            // 高亮P2
                            gameFromViewModel.perionds_highlight = [1]
                        })
                    }
                } else { // P2已经比赛结束，但比赛尚未结束
                    //P2已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [1] {
                        // P2已经高亮，再次点击
                    } else {
                        Button("View P2", role: .destructive, action: {
                            // 切换到小节：P2
                            gameFromViewModel.perionds_highlight = [1]
                        })
                    }
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分P2是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(1) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else{
                        Button("Do Not Select P2", action: {
                            gameFromViewModel.perionds_highlight.remove(1)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select P2", action: {
                        gameFromViewModel.perionds_highlight.insert(1)
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            gameFromViewModel.processMultiSelectPeriod()
                        }
                    })
                }
            }
            
            // 按钮Cancel，处理：比赛未开始，则不显示
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            } else {
                // 按钮：Cancel
                Button("Cancel", role: .cancel, action: {})
            }
        }, message: {
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                Text("Game has not started yet, \nPlease click \"Start\" button to start game")
            } else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P2是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 2 { // P2 尚未开始
                    Text("P2 has not started yet, \nOnly after P1 ends, P2 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 2 { // P2：比赛中
                    // P2：比赛中
                    Text("P2 is playing")
                } else { // P2已经比赛结束，但比赛尚未结束
                    //P2已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [1] {
                        // P2已经高亮，再次点击
                        Text("You're Viewing P2")
                    } else {
                        Text("P2 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        .alert("P3 tapped", isPresented: $gameFromViewModel.tap_period3, actions: {
            // 区分P3是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P3是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 3 { // P3 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 3 { // P3：比赛中，比赛中的小节为数组中最后的小节
                    // P3：比赛中，两种情况
                    // 如果当前的高亮小节是P3，则有2个按钮。
                    // 如果当前的高亮小节不是P3，则返回到P3，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [2] {
                        // 如果当前的高亮小节是P3，则有2个按钮。
                        // 第一个按钮：结束P3，开始P4
                        Button("Stop P3，Start P4", role: .destructive, action: {
                            // 开始下一个小节：P4
                            gameFromViewModel.beginNextPeriod()
                        })
                        
                        // 第二个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to P3 Playing", role: .destructive, action: {
                            // 切换到小节：P3
                            // 高亮P3
                            gameFromViewModel.perionds_highlight = [2]
                        })
                    }
                } else { // P3已经比赛结束，但比赛尚未结束
                    //P3已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [2] {
                        // P3已经高亮，再次点击
                    } else {
                        Button("View P3", role: .destructive, action: {
                            // 切换到小节：P3
                            gameFromViewModel.perionds_highlight = [2]
                        })
                    }
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分P3是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(2) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select P3", action: {
                            gameFromViewModel.perionds_highlight.remove(2)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select P3", action: {
                        gameFromViewModel.perionds_highlight.insert(2)
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            gameFromViewModel.processMultiSelectPeriod()
                        }
                    })
                }
            }
            
            // 按钮Cancel，处理：比赛未开始，则不显示
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            } else {
                // 按钮：Cancel
                Button("Cancel", role: .cancel, action: {})
            }
        }, message: {
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                Text("Game has not started yet, \nPlease click \"Start\" button to start game")
            } else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P3是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 3 { // P3 尚未开始
                    Text("P3 has not started yet, \nOnly after P2 ends, P3 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 3 { // P3：比赛中
                    // P3：比赛中
                    Text("P3 is playing")
                } else { // P3已经比赛结束，但比赛尚未结束
                    //P3已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [2] {
                        // P3已经高亮，再次点击
                        Text("You're Viewing P3")
                    } else {
                        Text("P3 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        .alert("P4 tapped", isPresented: $gameFromViewModel.tap_period4, actions: {
            // 区分P4是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P4是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 4 { // P4 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 4 { // P4：比赛中，比赛中的小节为数组中最后的小节
                    // P4：比赛中，两种情况
                    // 如果当前的高亮小节是P4，则有2个按钮。
                    // 如果当前的高亮小节不是P4，则返回到P4，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [3] {
                        // 如果当前的高亮小节是P4，则有2个按钮。
                        // 第一个按钮：结束P4，开始O1
                        Button("Stop P4，Start O1", role: .destructive, action: {
                            // 开始下一个小节：O1
                            gameFromViewModel.beginNextPeriod()
                        })
                        
                        // 第二个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to P4 Playing", role: .destructive, action: {
                            // 切换到小节：P4
                            // 高亮P4
                            gameFromViewModel.perionds_highlight = [3]
                        })
                    }
                } else { // P4已经比赛结束，但比赛尚未结束
                    //P4已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [3] {
                        // P4已经高亮，再次点击
                    } else {
                        Button("View P4", role: .destructive, action: {
                            // 切换到小节：P4
                            gameFromViewModel.perionds_highlight = [3]
                        })
                    }
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分P4是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(3) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select P4", action: {
                            gameFromViewModel.perionds_highlight.remove(3)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select P4", action: {
                        gameFromViewModel.perionds_highlight.insert(3)
                        
                        if gameFromViewModel.perionds_highlight.count >= 2 {
                            gameFromViewModel.processMultiSelectPeriod()
                        }
                    })
                }
            }
            
            // 按钮Cancel，处理：比赛未开始，则不显示
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            } else {
                // 按钮：Cancel
                Button("Cancel", role: .cancel, action: {})
            }
        }, message: {
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                Text("Game has not started yet, \nPlease click \"Start\" button to start game")
            } else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分P4是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 4 { // P4 尚未开始
                    Text("P4 has not started yet, \nOnly after P3 ends, P4 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 4 { // P4：比赛中
                    // P4：比赛中
                    Text("P4 is playing")
                } else { // P4已经比赛结束，但比赛尚未结束
                    //P4已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [3] {
                        // P4已经高亮，再次点击
                        Text("You're Viewing P4")
                    } else {
                        Text("P4 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        
        
        
        
        
        
    
    }
    
    /// 用于测试
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
