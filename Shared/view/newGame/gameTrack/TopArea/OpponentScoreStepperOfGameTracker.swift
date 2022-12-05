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
            Text(gameFromViewModel.perionds_highlight.count == 1 ? "\(gameFromViewModel.periodDataOfOpponentTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].score)" : "-")
                .frame(width: 80, height: 48, alignment: .center)
                .font(.system(size: 28))
                .background {
                    Color.white
                }
                .border(.green, width: 2)
            
            // 2. 步进器：入参（变化值）：$gameFromViewModel.periodDataOfOpponentTeamFromViewModels.last!.score
//            Stepper("", value: $gameFromViewModel.periodDataOfOpponentTeamFromViewModels.last!.score, in: 0...200, step: 1)
//                .frame(width: 85, height: 40, alignment: .center)
            
            StepperView(gameFromViewModel: gameFromViewModel)
                .frame(width: 85, height: 40, alignment: .center)
                
        }
        .frame(width: 90, height: 120, alignment: .center)
        // 太长会报错，因此放在将加时赛的O1放在这里
        .alert("O1 tapped", isPresented: $gameFromViewModel.tap_period5, actions: {
            // 区分O1是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分O1是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 5 { // O1 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 5 { // O1：比赛中，比赛中的小节为数组中最后的小节
                    // O1：比赛中，两种情况
                    // 如果当前的高亮小节是O1，则有2个按钮。
                    // 如果当前的高亮小节不是O1，则返回到O1，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [4] {
                        // 如果当前的高亮小节是O1，则有2个按钮。
                        // 第一个按钮：结束O1，开始O2
                        Button("Stop O1，Start O2", role: .destructive, action: {
                            // 开始下一个小节：O2
                            gameFromViewModel.beginNextPeriod()
                        })
                        
                        // 第二个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to O1 Playing", role: .destructive, action: {
                            // 切换到小节：O1
                            // 高亮O1
                            gameFromViewModel.perionds_highlight = [4]
                        })
                    }
                } else { // O1已经比赛结束，但比赛尚未结束
                    //O1已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [4] {
                        // O1已经高亮，再次点击
                    } else {
                        Button("View O1", role: .destructive, action: {
                            // 切换到小节：O1
                            gameFromViewModel.perionds_highlight = [4]
                        })
                    }
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分O1是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(4) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select O1", action: {
                            gameFromViewModel.perionds_highlight.remove(4)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                    
                } else {
                    // 未包含，改为：选则
                    Button("Do Select O1", action: {
                        gameFromViewModel.perionds_highlight.insert(4)
                        
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
                // 区分O1是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 5 { // O1 尚未开始
                    Text("O1 has not started yet, \nOnly after P4 ends, O1 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 5 { // O1：比赛中
                    // O1：比赛中
                    Text("O1 is playing")
                } else { // O1已经比赛结束，但比赛尚未结束
                    //O1已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [4] {
                        // O1已经高亮，再次点击
                        Text("You're Viewing O1")
                    } else {
                        Text("O1 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        .alert("O2 tapped", isPresented: $gameFromViewModel.tap_period6, actions: {
            // 区分O2是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分O2是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 6 { // O2 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 6 { // O2：比赛中，比赛中的小节为数组中最后的小节
                    // O2：比赛中，两种情况
                    // 如果当前的高亮小节是O2，则有2个按钮。
                    // 如果当前的高亮小节不是O2，则返回到O2，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [5] {
                        // 如果当前的高亮小节是O2，则有2个按钮。
                        // 第一个按钮：结束O2，开始O3
                        Button("Stop O2，Start O3", role: .destructive, action: {
                            // 开始下一个小节：O3
                            gameFromViewModel.beginNextPeriod()
                        })
                        
                        // 第二个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to O2 Playing", role: .destructive, action: {
                            // 切换到小节：O2
                            // 高亮O2
                            gameFromViewModel.perionds_highlight = [5]
                        })
                    }
                } else { // O2已经比赛结束，但比赛尚未结束
                    //O2已经比赛结束，但比赛尚未结束
                    // 最想做的事情：切换小节，修改数据
                    // 第一个按钮
                    if gameFromViewModel.perionds_highlight == [5] {
                        // O2已经高亮，再次点击
                    } else {
                        Button("View O2", role: .destructive, action: {
                            // 切换到小节：O2
                            gameFromViewModel.perionds_highlight = [5]
                        })
                    }
                }
                
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分O2是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(5) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select O2", action: {
                            gameFromViewModel.perionds_highlight.remove(5)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select O2", action: {
                        gameFromViewModel.perionds_highlight.insert(5)
                        
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
                // 区分O2是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 6 { // O2 尚未开始
                    Text("O2 has not started yet, \nOnly after O1 ends, O2 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 6 { // O2：比赛中
                    // O2：比赛中
                    Text("O2 is playing")
                } else { // O2已经比赛结束，但比赛尚未结束
                    //O2已经比赛结束，但比赛尚未结束
                    if gameFromViewModel.perionds_highlight == [5] {
                        // O2已经高亮，再次点击
                        Text("You're Viewing O2")
                    } else {
                        Text("O2 is over")
                    }
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        .alert("O3 tapped", isPresented: $gameFromViewModel.tap_period7, actions: {
            // 区分O3是否正在比赛：比赛中，比赛结束
            if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
                // 比赛尚未开始，提示，点击 Start 按钮开始比赛
                // 第二个按钮：结束比赛
                Button("First To Start Game", action: {
                    
                })
            }
            else if gameFromViewModel.status_Game == 1 { // 比赛正在进行
                // 区分O3是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 7 { // O3 尚未开始
                    
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 7 { // O3：比赛中，比赛中的小节为数组中最后的小节
                    // O3：比赛中，两种情况
                    // 如果当前的高亮小节是O3，则有1个按钮。
                    // 如果当前的高亮小节不是O3，则返回到O3，进行查看。
                    
                    if gameFromViewModel.perionds_highlight == [6] {
                        // 如果当前的高亮小节是O3，则有1个按钮。
                        // 第1个按钮：结束比赛
                        Button("Game Over", action: {
                            gameFromViewModel.status_Game = 2 // 比赛结束
                        })
                    } else {
                        // 仅一个按钮
                        Button("Back to O3 Playing", role: .destructive, action: {
                            // 切换到小节：O3
                            // 高亮O3
                            gameFromViewModel.perionds_highlight = [6]
                        })
                    }
                } else {
                    
                }
                  
            } else if gameFromViewModel.status_Game == 2 { // 比赛结束
                // 区分O3是否正在比赛：比赛结束，一个按钮，选中(若未选中)或者取消(若已选中)
                if gameFromViewModel.perionds_highlight.contains(6) {
                    // 包含，改为：不选
                    if gameFromViewModel.perionds_highlight.count == 1 {
                        Button("At least one period must be selected", action: {
                        })
                    } else {
                        Button("Do Not Select O3", action: {
                            gameFromViewModel.perionds_highlight.remove(6)
                            
                            if gameFromViewModel.perionds_highlight.count >= 2 {
                                gameFromViewModel.processMultiSelectPeriod()
                            }
                        })
                    }
                } else {
                    // 未包含，改为：选则
                    Button("Do Select O3", action: {
                        gameFromViewModel.perionds_highlight.insert(6)
                        
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
                // 区分O3是否正在比赛：比赛中：2个按钮
                if gameFromViewModel.periodDataOfMyTeamFromViewModels.count < 7 { // O3 尚未开始
                    Text("O3 has not started yet, \nOnly after O2 ends, O3 can start")
                } else if gameFromViewModel.periodDataOfMyTeamFromViewModels.count == 7 { // O3：比赛中
                    // O3：比赛中
                    Text("O3 is playing")
                } else {
                    
                }
            }
            else if gameFromViewModel.status_Game == 2 { // 比赛结束
                Text("Game is over")
            }
        })
        
    }
}

struct OpponentScoreStepperOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        // 入参：gameFromViewModel: GameFromViewModel()
        OpponentScoreStepperOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}

/// 步进器：对方球队小节得分
///
/// 入口保护条件
/// - 比赛尚未开始，不能计分
/// - 选择多个小节，不能修改数据
/// - 得分不能 小于 0
struct StepperView: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    /// 加分：对方球队的小节计分器
    func incrementStep() {
        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
            return
        }
        
        if gameFromViewModel.perionds_highlight.count >= 2 { // 选择多个小节，不能修改数据
            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
            return
        }
        
        gameFromViewModel.counter_tap_Stepper += 1
        gameFromViewModel.periodDataOfOpponentTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].score += 1
    }
    
    /// 减分：对方球队的小节计分器
    ///
    /// 约束条件
    /// - 得分不能 < 0
    func decrementStep() {
        if gameFromViewModel.status_Game == 0 { // 比赛尚未开始
            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
            return
        }
        
        if gameFromViewModel.perionds_highlight.count >= 2 { // 选择多个小节，不能修改数据
            gameFromViewModel.tap_player_Alert_CannotModifyData.toggle()
            return
        }
        
        gameFromViewModel.counter_tap_Stepper -= 1
        gameFromViewModel.periodDataOfOpponentTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].score -= 1
        if gameFromViewModel.periodDataOfOpponentTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].score < 0 { gameFromViewModel.periodDataOfOpponentTeamFromViewModels[gameFromViewModel.perionds_highlight.first!].score = 0 }
    }
    
    var body: some View {
        Stepper {
            Text("")
        } onIncrement: {
            incrementStep() // 加
        } onDecrement: {
            decrementStep() // －
        }
    }
}
