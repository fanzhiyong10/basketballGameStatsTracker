//
//  SelectTeam.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/28.
// 

import SwiftUI

/// 主队：选择首发上场的5个人球员
///
/// 球员列表
struct SelectTeam: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: Team.entity(), sortDescriptors: []
    )
    private var teams: FetchedResults<Team>
    
    // 球员
    @FetchRequest(
        entity: Player.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    )
    private var players: FetchedResults<Player>
    

    //MARK: 跟踪状态变化
    // 比赛，注意：初始化
    @ObservedObject private var gameFromViewModel: GameFromViewModel = GameFromViewModel()
    
    // 跟踪球员的变化：@Published，变化时则通知
    // 因为是数组不是@ObservedObject，需要改用@State
//    @ObservedObject private var playerFromViewModels: [PlayerFromViewModel]
    @State private var playerFromViewModels = [PlayerFromViewModel]()
    
    @Binding var rootIsActive : Bool
    
    var body: some View {
        HStack {
            VStack {
                // 我队
                Text("My Team")
                    .font(.title)
                    .padding(20)
                
                Text(gameFromViewModel.name_my_team == "" || playerFromViewModels.count == 0 ? "Please Select" :  gameFromViewModel.name_my_team)
                    .font(.title2)
                    .foregroundColor(gameFromViewModel.name_my_team == "" || playerFromViewModels.count == 0 ? Color.red :  Color.green)
                
                List {
                    ForEach(teams, id: \.self) { team in
                        HStack {
                            Text(team.name)
                            Spacer()
                            Text(team.fullName)
                        }
                        .onTapGesture {
                            // 点击，则选中
                            gameFromViewModel.setupMyTeam(team: team)
                            
                            let arr = team.ids_player.split(separator: ",")
                            var arr_Int = [Int]()
                            for item in arr {
                                if let aInt = Int(item) {
                                    arr_Int.append(aInt)
                                }
                            }
                            
                            for player in players {
                                if arr_Int.contains(player.id) {
                                    playerFromViewModels.append(PlayerFromViewModel(player: player))
                                }
                            }
                        }
                    }
                }
            }
            
            VStack {
                // 对手
                Text("Opponent Team")
                    .font(.title)
                    .padding(20)
                
                Text(gameFromViewModel.name_opponent_team == "" ? "Please Select" :  gameFromViewModel.name_opponent_team)
                    .font(.title2)
                    .foregroundColor(gameFromViewModel.name_opponent_team == "" ? Color.red :  Color.green)

                List {
                    ForEach(teams, id: \.self) { team in
                        HStack {
                            Text(team.name)
                            Spacer()
                            Text(team.fullName)
                        }
                        .onTapGesture {
                            // 点击，则选中
                            gameFromViewModel.setupOppenengTeam(team: team)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Teams to Play")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if gameFromViewModel.name_my_team != "" && gameFromViewModel.name_opponent_team != "" && playerFromViewModels.count > 0 {
                    NavigationLink {
                        // 跳转到另一个页面
                        SelectStartingPlayers(gameFromViewModel: gameFromViewModel, playerFromViewModels: $playerFromViewModels, shouldPopToRootView: self.$rootIsActive)
                    } label: {
                        // 区分双方
                        Text("Next")
                    }
                    .isDetailLink(false)
                }
            }
        }
        
        
    }
    
    /// 保存：球队信息
    ///
    /// 对应ID：自增设计
    private func save() {
        print("save()")
        return
        let game = Game(context: context)
        
        // id
        let aint = UserDefaults.standard.integer(forKey: "id_Game")
        game.id = aint + 1
        UserDefaults.standard.set(game.id, forKey: "id_Game")
        
        game.id_my_team = gameFromViewModel.id_my_team
        game.id_opponent_team = gameFromViewModel.id_opponent_team
        game.name_my_team = gameFromViewModel.name_my_team
        game.name_opponent_team = gameFromViewModel.name_opponent_team

        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

/*
struct SelectTeam_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeam()
    }
}
*/

struct SelectTeam2: View {
    // 比赛
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    var body: some View {
        VStack {
            Text("Select2 Team")
            Text(gameFromViewModel.name_my_team)
        }
        .navigationBarHidden(true) // 去掉导航栏
    }
}

struct SelectTeam2_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeam2(gameFromViewModel: GameFromViewModel())
    }
}
