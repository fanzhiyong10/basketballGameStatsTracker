//
//  SubstitutePlayersTableOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/2.
//

import SwiftUI

struct SubstitutePlayersTableOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    // 提示
    @State private var alert_Not5Players = false
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            List {
                Section {
                    ForEach(gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.indices, id:\.self) { index in
                        HStack {
                            Text("\(gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].player)  # \(gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].number)")
                                .foregroundColor(gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup ? .green : nil)
                                .padding(.leading, 30)
                            
                            Spacer()
                            
                            if gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup {
                                // 显示标记
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.blue)
                                    .padding(.trailing, 30)
                            }
                        }
                        .frame(width: 500, height: 48) // 行高 60
                        .font(.title)
                        .listRowSeparator(.hidden) // 行分割线：隐藏
                        .background { // 行背景色
                            if index % 2 == 0 {
                                Color.gray.opacity(0.3)
                            } else {
                                Color.gray.opacity(0.1)
                            }
                        }
                        .onTapGesture {
                            print("onTapGesture")
                            gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup.toggle()
                            gameFromViewModel.counter_tap_subsititue += 1
                        }
                    }
                } header: { // 表头
                    HStack {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.leading, 30)
                            .onTapGesture {
                                // 取消
                                self.cancel()
                                
                                // 关闭窗口
                                self.gameFromViewModel.isOnPlayers.toggle()
                            }
                        
                        Spacer()
                        
                        Text("Substitue Players")
                            .font(.title)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.trailing, 30)
                            .onTapGesture {
                                // 保存
                                if self.save() == true {
                                    // 成功保存：关闭窗口
                                    self.gameFromViewModel.isOnPlayers.toggle()
                                }
                            }
                    }
                    .frame(width: 500, height: 60) // 行高
                    .background(Color.orange)
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) // leading 8

            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
            .frame(width: 500, alignment: .center)
            
            Spacer()
        }
        .alert("Must be 5 players", isPresented: $alert_Not5Players, actions: {
            
        })
        
    }
    
    // 取消
    func cancel() {
        for index in 0...gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.count-1 {
            gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup = gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt
        }
    }
    
    /// 保存
    ///
    /// 入口保护条件
    /// - 上场球员必须正好 5 人
    func save() -> Bool {
        // 入口条件
        var counter_OnCourt = 0
        
        for index in 0...gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.count-1 {
            if gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup == true {
                counter_OnCourt += 1
            }
        }
        
        if counter_OnCourt != 5 {
            // 请选择球员，场上球员必须5人
            self.alert_Not5Players.toggle()
            return false
        }
        
        // 1）保存
        for index in 0...gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.count-1 {
            gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt = gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels[index].isOnCourt_backup
        }
        
        // 2）排序
        gameFromViewModel.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels.sort {
            // 先排序：isOnCourt
            if $0.isOnCourt == false && $1.isOnCourt == true {
                return false
            }
            
            if $0.isOnCourt == true && $1.isOnCourt == false {
                return true
            }
            
            // 再排序：球员人名
            return $0.player < $1.player
        }
        
        return true
    }
}

struct SubstitutePlayersTableOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        SubstitutePlayersTableOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
