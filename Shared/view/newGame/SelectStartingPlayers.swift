//
//  SelectStartingPlayers.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/28.
//

import SwiftUI

/// 选择首发上场球员
///
/// 第一小节
/// - isOnCourt
struct SelectStartingPlayers: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    //MARK: - 全局环境变量 状态控制
    @EnvironmentObject var mainStates: MainStateControl

    
    //MARK: FromViewModel
    // 比赛
    @ObservedObject var gameFromViewModel: GameFromViewModel
    
    //MARK: 跟踪状态变化：class，属性@Published
    @Binding var playerFromViewModels: [PlayerFromViewModel]

    //MARK: 上场人数的跟踪，使用@State
    @State var counter_OnCourt = 0

    @Binding var shouldPopToRootView : Bool

    var body: some View {
        HStack(alignment: .center) {
            List {
                ForEach(0...playerFromViewModels.count-1, id:\.self) { index in
                    HStack {
                        Text("\(playerFromViewModels[index].name)  # \(playerFromViewModels[index].number)")
                            .foregroundColor(playerFromViewModels[index].isOnCourt ? .green : nil)
                            .padding(.leading, 30)
                        
                        Spacer()
                        
                        
                        if playerFromViewModels[index].isOnCourt {
                            // 显示标记
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.blue)
                                .padding(.trailing, 30)
                        }
                    }
                    .frame(width: 500, height: 40) // 行高
                    .font(.title2)
                    .listRowSeparator(.hidden) // 行分割线：隐藏
                    .background { // 行背景色
                        if index % 2 == 0 {
                            Color.gray.opacity(0.3)
                        } else {
                            Color.gray.opacity(0.1)
                        }
                    }
                    .onTapGesture {
                        print("index: \(index)")
                        playerFromViewModels[index].isOnCourt.toggle()
                        
                        // 跟踪：上场人数
                        counter_OnCourt += playerFromViewModels[index].isOnCourt ? 1 : -1
                        print("counter_OnCourt: \(counter_OnCourt)")
                        
                        // 点击球员，跟踪显示
                        playerFromViewModels[index].showAlert.toggle()
                    }
                    .alert(isPresented: $playerFromViewModels[index].showAlert) {
                        // 弹窗提示：点击球员，跟踪显示，上场球员的数量
                        var anAlert: Alert
                        
                        if counter_OnCourt < 5 {
                            anAlert = Alert(title: Text("less than 5"), message: Text("Need 5 players on court"), dismissButton: .default(Text("OK")))
                        } else if counter_OnCourt > 5 {
                            anAlert = Alert(title: Text("more than 5"), message: Text("Need 5 players on court"), dismissButton: .default(Text("OK")))
                        } else {
                            anAlert = Alert(title: Text("Exactly 5"), message: Text("Need 5 players on court"), dismissButton: .default(Text("OK")))
                        }
                        
                        
                        return anAlert
                    }
                    
                }
            }
        }
        .navigationTitle("My Team : Select Starting Players")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if counter_OnCourt == 5 {
                    // 选中5人，则出现提示
                    Button {
                        // 1. 保存
                        save()
                        
                        // 2. 比赛实时数据跟踪页面的状态：显示跟踪
                        mainStates.trackerPageStatus = .EnterTracker
                        
                        // 3. 返回到比赛跟踪页面: GameTracker
                        self.shouldPopToRootView = false
                    } label: {
                        Text("Go") // 开始比赛，进入比赛跟踪界面：GameTracker
                    }
                }
            }
        }
    }
    
    
    /// 保存：比赛信息，两个球队
    ///
    ///初始化信息
    ///1. 比赛：球队
    ///2. 小节1：我方、对方
    ///3. 我方队员：队员 + 首发球员
    ///
    /// 对应ID：自增设计
    private func save() {
        // 比赛初始数据的生成时间
        let date_created = Int(Date().timeIntervalSince1970) // 精确到秒
        
        let game = Game(context: context)
        let periodDataOfMyTeam = PeriodDataOfMyTeam(context: context)
        let periodDataOfOpponentTeam = PeriodDataOfOpponentTeam(context: context)

        // id
        do {
            let aint = UserDefaults.standard.integer(forKey: "id_Game")
            game.id = aint + 1
            UserDefaults.standard.set(game.id, forKey: "id_Game")
        }
        
        do {
            let aint = UserDefaults.standard.integer(forKey: "id_PeriodDataOfMyTeam")
            periodDataOfMyTeam.id = aint + 1
            UserDefaults.standard.set(periodDataOfMyTeam.id, forKey: "id_PeriodDataOfMyTeam")
        }
        
        do {
            let aint = UserDefaults.standard.integer(forKey: "id_PeriodDataOfOpponentTeam")
            periodDataOfOpponentTeam.id = aint + 1
            UserDefaults.standard.set(periodDataOfOpponentTeam.id, forKey: "id_PeriodDataOfOpponentTeam")
        }
        
        // 1. game
        game.id_my_team = gameFromViewModel.id_my_team
        game.id_opponent_team = gameFromViewModel.id_opponent_team
        game.name_my_team = gameFromViewModel.name_my_team
        game.name_opponent_team = gameFromViewModel.name_opponent_team
        game.ids_PeriodDataOfMyTeam = "\(periodDataOfMyTeam.id)"
        game.ids_PeriodDataOfOpponentTeam = "\(periodDataOfOpponentTeam.id)"
        game.date_created = date_created
        
        // 测试：输出数据
        print(game.output())
        
        // 2. periodDataOfMyTeam
        periodDataOfMyTeam.id_game = game.id
        periodDataOfMyTeam.id_my_team = game.id_my_team
        periodDataOfMyTeam.name_period = "P1"
        periodDataOfMyTeam.score = 0
        periodDataOfMyTeam.date_created = date_created // 精确到秒
        
        // 2.1 ids_PlayerLiveData
        var strs = ""
        // 如果在循环里面，会发生错误
        var aint = UserDefaults.standard.integer(forKey: "id_PlayerLiveData") // 当前保存的
        for pfvm in playerFromViewModels {
            aint += 1
            let pld = PlayerLiveData(context: context)
            
            pld.id = aint
            
            strs += "\(pld.id),"
            
            pld.id_game = game.id
            pld.id_my_team = game.id_my_team
            pld.id_period = periodDataOfMyTeam.id
            
            pld.id_player = pfvm.id
            pld.name_player = pfvm.name
            pld.number = pfvm.number
            pld.isOnCourt = pfvm.isOnCourt
            
            pld.time_cumulative = 0
            pld.ids_ItemLiveData = ""
        }
        periodDataOfMyTeam.ids_PlayerLiveData = strs
        
        UserDefaults.standard.set(aint, forKey: "id_PlayerLiveData") // 保存最大的

        // 测试：输出数据
        print(periodDataOfMyTeam.output())
        
        // 3. periodDataOfOpponentTeam
        periodDataOfOpponentTeam.id_game = game.id
        periodDataOfOpponentTeam.id_opponent_team = game.id_opponent_team
        periodDataOfOpponentTeam.name_period = "P1"
        periodDataOfOpponentTeam.score = 0
        periodDataOfOpponentTeam.date_created = date_created // 小节两队同一个时间

        // 测试：输出数据
        print(periodDataOfOpponentTeam.output())
        
        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

/*
struct SelectStartingPlayers_Previews: PreviewProvider {
    static var previews: some View {
        SelectStartingPlayers(gameFromViewModel: GameFromViewModel(), playerFromViewModels: .constants([PlayerFromViewModel]()))
    }
}
*/
