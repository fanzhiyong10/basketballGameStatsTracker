//
//  GameClockViewOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

/// 比赛计时器
///
/// 工作逻辑
/// - 点击按钮START，开始计时，同时：隐藏按钮START，显示按钮STOP
///
/// 设计思路
/// - 使用Timer，重复，每秒1次
/// - 计时器显示文本 onReceive(timer)
/// - 状态控制：started，显示的按钮（START、STOP）及 是否对计时器进行累加
struct GameClockViewOfGameTracker: View {
    //MARK: - 全局环境变量 状态控制，@EnvironmentObject：An environment object invalidates the current view whenever the observable object changes.
    @EnvironmentObject var mainStates: MainStateControl

    //MARK: -  我队的比赛数据 1.必须确保生成，@ObservedObject：A property wrapper type that subscribes to an observable object and invalidates a view whenever the observable object changes.
    @ObservedObject var gameFromViewModel: GameFromViewModel

    //MARK: - 比赛计时器，每个1秒钟更新一次（重复），1）点击start开始计时，2）点击stop停止计时
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(gameFromViewModel: GameFromViewModel) {
        self.gameFromViewModel = gameFromViewModel
    }
    
    var body: some View {

            VStack(alignment: .center, spacing: 10) {
                Text("\(calGameClock(game_cum_duration: gameFromViewModel.game_cum_duration))")
                    .frame(width: 350)
                    .font(.system(size: 32))
                    .foregroundColor(.green)
                    .onReceive(timer) { time in
                        if gameFromViewModel.started == true {
                            // 开始后，计时器：累加
                            gameFromViewModel.game_cum_duration += 1
                            
                            // 发出通知：场上球员累计计时
                            // 注：通知的方式，会造成 主表和放大显示的表同时计算，重复计算，计算了2次，因此去掉
//                            NotificationCenter.default.post(name: .time_count, object: self)
                            
                            for (index, player) in gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.enumerated() {
                                if player.isOnCourt {
                                    gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].time_cumulative += 1
                                }
                            }
                            
                            //MARK: 清除临时目录：待优化
                            FileManager.default.clearTmpDirectory()
                        }
                    }
                
                HStack(alignment: .center) {
                    
                    // 对齐：左侧
                    if gameFromViewModel.started == false {
                        Button(action: {
                            print("Start")
                            gameFromViewModel.started = true
                        }) {
                            Text("START")
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.system(size: 12))
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    } else {
                        Button(action: {
                            print("Stop")
                            // 停止
                            gameFromViewModel.started = false
                        }) {
                            Text("STOP")
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.system(size: 12))
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    
                    // 对齐
                    Spacer()
                    
                    // 对齐：右侧
                    Image(systemName: "plus.magnifyingglass")
                        .font(.system(size: 50))
                        .onTapGesture {
                            print("plus.magnifyingglass")
                            gameFromViewModel.isOnZoomin.toggle()
                        }
                    
                    Spacer()
                    
                    Text("PLAYERS")
                        .frame(width: 120, height: 40, alignment: .center)
                        .font(.title2)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            
                            gameFromViewModel.isOnPlayers.toggle()
                        }

                }
                .frame(width: 350.0)
                
            }
        
        
    }
    
    /// 计时器 换算为显示的 时：分：秒
    func calGameClock(game_cum_duration: Float) -> String {
        let hours = Int(game_cum_duration / 3600)
        let minutes = Int((game_cum_duration - Float(hours) * 3600) / 60)
        let seconds = Int(game_cum_duration - Float(hours) * 3600 - Float(minutes * 60))
        var str = "Game Clock  "
        str += String(format: "%02d", hours) + " : "
        str += String(format: "%02d", minutes) + " : "
        str += String(format: "%02d", seconds)
        
        return str
    }
}

struct GameClockViewOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        GameClockViewOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
