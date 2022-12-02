//
//  EditTeamView.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/19.
//

import SwiftUI

///修改球队
///
///修改内容
///-球队名字：全名、简称
///-球队中的球员：选择
struct EditTeamView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: Player.entity(), sortDescriptors: []
    )
    private var players: FetchedResults<Player>
    
    // 用于添加删除球员，另外一种解决思路
//    @ObservedObject private var teamIncludePlayers = TeamIncludePlayers()
    
    // 球队
    @ObservedObject private var teamFromViewModel: TeamFromViewModel
    
    @ObservedObject var team: Team

    init(team: Team) {
        self.team = team
        teamFromViewModel = TeamFromViewModel()
        teamFromViewModel.fullName = team.fullName
        teamFromViewModel.name = team.name
        teamFromViewModel.ids_player = team.ids_player
        teamFromViewModel.selectedPlayers = team.calSetOfPlayer()
        
        // 用于添加删除球员，另外一种解决思路
//        teamIncludePlayers.selectedPlayers = team.calSetOfPlayer()
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 20) {
                FormTextField(label: "Full Name", placeholder: "Fill in the full name", value: $teamFromViewModel.fullName)
                
                FormTextField(label: "Short Name", placeholder: "Fill in the short name", value: $teamFromViewModel.name)
            }
            
            Text("Select Players")
                .font(.system(size: 32))
                .padding(20)
            
            HStack(alignment: .center, spacing: 10) {
                VStack(spacing:10) {
                    Text("unselected players")
                        .font(.system(size: 20))
//                        .padding(20)
                    
                    // 未选中的列表
                    List {
                        ForEach(players, id: \.self) { player in
                            // 算法：未选中的
                            if teamFromViewModel.selectedPlayers.contains(player.id) == false {
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Text(player.number)
                                    Spacer()
                                    Text(player.fullName)
                                }
                                .onTapGesture {
                                    // 点击，则选中
                                    teamFromViewModel.selectedPlayers.insert(player.id)
                                }
                            }
                        }
                    }
//                    .padding(10)
                }
                
                
                
                
                Image(systemName: "arrow.left.arrow.right")
                    .frame(width: 100, height: 40)
                    .font(.system(size: 40))
                    .foregroundColor(Color.blue)
                
                VStack(spacing:10) {
                    Text("selected players")
                        .font(.system(size: 20))
                        .foregroundColor(Color.green)
//                        .padding(20)
                    
                    // 已经选中的列表
                    List {
                        ForEach(players, id: \.self) { player in
                            // 算法：选中的，集合中包含
                            if teamFromViewModel.selectedPlayers.contains(player.id) == true {
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Text(player.number)
                                    Spacer()
                                    Text(player.fullName)
                                }
                                .foregroundColor(Color.green)
                                .onTapGesture {
                                    // 点击，则未选中
                                    teamFromViewModel.selectedPlayers.remove(player.id)
                                }
                            }
                        }
                    }
//                    .padding(10)
                }
                
            }
            
        }
        .padding(20)
        .navigationTitle("Edit Team")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    save()
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                }
            }
        }
    }
    
    /// 更新
    ///
    /// 步骤
    /// 1. 赋值：新的
    /// 2. 存储
    private func save() {
        // 更新
        team.fullName = teamFromViewModel.fullName
        team.name = teamFromViewModel.name

        // 排序
        let anArray = Array(teamFromViewModel.selectedPlayers).sorted(by: <)

        // 构建字符串
        var str = ""
        for (index, aInt) in anArray.enumerated() {
            if index == 0 {
                // 第一个
                str = "\(aInt),"
            } else if index == anArray.count - 1 {
                // 最后一个
                str += "\(aInt)"
            }
            else {
                // 中间
                str += "\(aInt)"
                
                str += ","
            }
        }
        
        team.ids_player = str
        teamFromViewModel.ids_player = str
        
        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

struct EditTeamView_Previews: PreviewProvider {
    static var previews: some View {
        EditTeamView(team: Team())
    }
}
