//
//  GameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/29.
// 

import SwiftUI
import CoreData

///主页面
///
///技巧
/// - 隐藏导航栏区域，该区域的对象会响应设定的事件
///
/// 实现过程
/// 1. 比赛的基础数据：球队、队员、首发球员
/// - 状态为First，生成数据
/// - 验证Core Data
/// 2. 基于基础数据，进行编码和测试
/// - 状态为EnterTracker，进行编码
/// - 逐步实现跟踪界面
struct GameTracker: View {
    //MARK: - 全局环境变量 项目创建时，自动生成
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - 全局环境变量 状态控制
    @EnvironmentObject var mainStates: MainStateControl
    
    //MARK: - Core Data，比赛数据
    // ==== Game
    @FetchRequest(
        entity: Game.entity(), sortDescriptors: []
    )
    private var games: FetchedResults<Game>
    
    // ==== PeriodDataOfMyTeam
    @FetchRequest(
        entity: PeriodDataOfMyTeam.entity(), sortDescriptors: []
    )
    private var periodDataOfMyTeams: FetchedResults<PeriodDataOfMyTeam>
    
    // ==== PeriodDataOfOpponentTeam
    @FetchRequest(
        entity: PeriodDataOfOpponentTeam.entity(), sortDescriptors: []
    )
    private var periodDataOfOpponentTeams: FetchedResults<PeriodDataOfOpponentTeam>
    
    //MARK: -  我队的比赛数据 1.必须确保生成
    @State var isActive : Bool = false
    
    //MARK: 跟踪状态变化
    // 比赛，注意：初始化
    @ObservedObject private var gameFromViewModel: GameFromViewModel = GameFromViewModel()
    
    init() {
        // 初始化获取数据
        // ==== 最近的比赛
        let aint = UserDefaults.standard.integer(forKey: "id_Game")
        
        // 获取比赛数据
        let fetchGames = NSFetchRequest<Game>(entityName: "Game")
        // 筛选条件
        fetchGames.predicate = NSPredicate(format: "id = \(aint)")
        do {
            // 使用传入的viewContext会报错
            // 需要使用PersistenceController.shared.container.viewContext
            let gamess = try PersistenceController.shared.container.viewContext.fetch(fetchGames)
            print("games count = \(gamess.count)")
            for game in gamess {
                print(game.output())
            }
            
            gameFromViewModel = GameFromViewModel(game: gamess.first)
        } catch {
            print("\(error)")
        }
        
        // ===== PlayerLiveDataFromViewModel
        let arr = gameFromViewModel.ids_PeriodDataOfMyTeam.split(separator: ",")
        var ids_PeriodDataOfMyTeam = [Int]()
        for item in arr {
            if let id = Int(String(item)) {
                ids_PeriodDataOfMyTeam.append(id)
            }
        }
        
        if ids_PeriodDataOfMyTeam.count == 1 {
            // 对方
            do {
                let arr = gameFromViewModel.ids_PeriodDataOfOpponentTeam.split(separator: ",")
                var ids_PeriodDataOfOpponentTeam = [Int]()
                for item in arr {
                    if let id = Int(String(item)) {
                        ids_PeriodDataOfOpponentTeam.append(id)
                    }
                }
                
                if ids_PeriodDataOfOpponentTeam.count == 1 {
                    do {
                        // 仅一个：小节1
                        let aint = ids_PeriodDataOfOpponentTeam.first!
                        let fetchPeriodDataOfOpponentTeams = NSFetchRequest<PeriodDataOfOpponentTeam>(entityName: "PeriodDataOfOpponentTeam")
                        // 筛选条件
                        fetchPeriodDataOfOpponentTeams.predicate = NSPredicate(format: "id = \(aint)")
                        
                        // 使用传入的viewContext会报错
                        // 需要使用PersistenceController.shared.container.viewContext
                        let periodDataOfOpponentTeams = try PersistenceController.shared.container.viewContext.fetch(fetchPeriodDataOfOpponentTeams)
                        print("periodDataOfOpponentTeams count = \(periodDataOfOpponentTeams.count)")
                        for periodDataOfOpponentTeam in periodDataOfOpponentTeams {
                            print(periodDataOfOpponentTeam.output())
                            
                            let periodDataOfOpponentTeamFromViewModel = PeriodDataOfOpponentTeamFromViewModel(periodDataOfOpponentTeam: periodDataOfOpponentTeam)
                            
                            self.gameFromViewModel.periodDataOfOpponentTeamFromViewModels.append(periodDataOfOpponentTeamFromViewModel)
                        }
                        
                    } catch {
                        print("\(error)")
                    }
                }
            }
            
            // 我方
            do {
                // 仅一个：小节1
                let aint = ids_PeriodDataOfMyTeam.first!
                let fetchPeriodDataOfMyTeams = NSFetchRequest<PeriodDataOfMyTeam>(entityName: "PeriodDataOfMyTeam")
                // 筛选条件
                fetchPeriodDataOfMyTeams.predicate = NSPredicate(format: "id = \(aint)")
                do {
                    // 使用传入的viewContext会报错
                    // 需要使用PersistenceController.shared.container.viewContext
                    let periodDataOfMyTeams = try PersistenceController.shared.container.viewContext.fetch(fetchPeriodDataOfMyTeams)
                    print("periodDataOfMyTeams count = \(periodDataOfMyTeams.count)")
                    for periodDataOfMyTeam in periodDataOfMyTeams {
                        print(periodDataOfMyTeam.output())
                        
                        let periodDataOfMyTeamFromViewModel = PeriodDataOfMyTeamFromViewModel(periodDataOfMyTeam: periodDataOfMyTeam)
                        
                        self.gameFromViewModel.periodDataOfMyTeamFromViewModels.append(periodDataOfMyTeamFromViewModel)
                    }
                    
                    print("测试")
                    // === player
                    if let p1 = self.gameFromViewModel.periodDataOfMyTeamFromViewModels.first {
                        let arr = p1.ids_PlayerLiveData.split(separator: ",")
                        var ids_PlayerLiveData = [Int]()
                        var str = "{ "
                        for (index, item) in arr.enumerated() {
                            if let id = Int(String(item)) {
                                ids_PlayerLiveData.append(id)
                                
                                if index == arr.count - 1 {
                                    str += "'" + String(item) + "'" + " "
                                } else {
                                    str += "'" + String(item) + "'," + " "
                                }
                            }
                        }
                        
                        str += "}"
                        
                        do {
                            let fetchPlayerLiveDatas = NSFetchRequest<PlayerLiveData>(entityName: "PlayerLiveData")
                            // 筛选条件
                            fetchPlayerLiveDatas.predicate = NSPredicate(format: "id IN \(str)")
                            // 排序
                            let sort1 = NSSortDescriptor(key: "isOnCourt", ascending: false)
                            let sort2 = NSSortDescriptor(key: "name_player", ascending: true)
                            fetchPlayerLiveDatas.sortDescriptors = [sort1, sort2]
                            do {
                                // 使用传入的viewContext会报错
                                // 需要使用PersistenceController.shared.container.viewContext
                                let playerLiveDatas = try PersistenceController.shared.container.viewContext.fetch(fetchPlayerLiveDatas)
                                print("players count = \(playerLiveDatas.count)")
                                
                                // PlayerLiveData
                                for playerLiveData in playerLiveDatas {
                                    print(playerLiveData.output())
                                    let playerLiveDataFromViewModel = PlayerLiveDataFromViewModel(playerLiveData: playerLiveData)
                                    
                                    self.gameFromViewModel.periodDataOfMyTeamFromViewModels[0].playerLiveDataFromViewModels.append(playerLiveDataFromViewModel)
                                }
                                
                                // 比赛刚开始，仅一个小节，球员数据就是 小节1 的数据
                                self.gameFromViewModel.playerLiveDataFromViewModels = self.gameFromViewModel.periodDataOfMyTeamFromViewModels[0].playerLiveDataFromViewModels
                                
                            } catch {
                                print("\(error)")
                            }
                        }
                    }
                    
                    
                } catch {
                    print("\(error)")
                }
            }
        }
        
    }
    
    /// 依据不同的状态，呈现不同的界面
    ///
    /// 各种状态
    /// 1. 比赛尚未开始
    /// 2. 进入比赛界面：EnterGame，尚未点击开始按钮
    /// 3. 比赛开始：Begin，点击开始按钮
    /// 4. 比赛结束：End，结束比赛
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 依据不同的状态，呈现不同的界面
            switch mainStates.trackerPageStatus {
            case .First:
                // 1. 不是跟踪tracker页面
                NavigationLink(
                    destination: SelectTeam(rootIsActive: self.$isActive),
                    isActive: self.$isActive
                ) {
                    Text("First: Select Teams to Play") // 第一步：选择参赛球队
                        .font(.title)
                }
                .isDetailLink(false)
                .navigationBarTitle("New Game")
                
            case .EnterTracker:
                /*
                // 测试方法
                List {
                    ForEach(games.indices, id: \.self) { index in
                        Text(games[index].output())
                    }
                }
                
                List {
                    ForEach(periodDataOfOpponentTeams.indices, id: \.self) { index in
                        Text(periodDataOfOpponentTeams[index].output())
                    }
                }
                */
                // 2. 进入跟踪tracker界面
                TopAreaViewOfGameTracker(gameFromViewModel: gameFromViewModel) //(liveDatas: $liveDatas)
                    .frame(height: 130, alignment: .topLeading)
                    .background(Color.init(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0))
                
                PlayerLiveDataTableOfGameTracker(gameFromViewModel: gameFromViewModel)
                    .ignoresSafeArea()
                    .overlay(alignment: .topLeading) {
                        if self.gameFromViewModel.isOnZoomin {
                            // 场上队员表：放大显示
                            VStack(spacing: 0) {
                                OnCourtPlayerLiveDataTableOfGameTracker(gameFromViewModel: gameFromViewModel)

                                // 白色填充，不让背后的表露出了
                                Color.white
                                    .frame(height: 100)
                            }
                            
                        }
                    }
                    .overlay(alignment: .center) {
                        if self.gameFromViewModel.isOnPlayers {
                            SubstitutePlayersTableOfGameTracker(gameFromViewModel: gameFromViewModel)
                        }
                    }
            }
        }
        .ignoresSafeArea() // 忽略
        .navigationBarHidden(true) // 隐藏导航栏区域，该区域的对象会响应设定的事件
        
    }
}

struct GameTracker_Previews: PreviewProvider {
    static var previews: some View {
        GameTracker()
    }
}
