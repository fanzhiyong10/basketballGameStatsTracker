//
//  Game.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/27.
//

import CoreData

public class Game: NSManagedObject {
    @NSManaged public var id: Int // id_Game
    
    // 关联
    @NSManaged public var id_my_team: Int
    @NSManaged public var id_opponent_team: Int
    
    // 属性
    @NSManaged public var date_created: Int // 比赛生成时间
    @NSManaged public var date_begin: Int // 比赛开始时间
    @NSManaged public var date_end: Int // 比赛结束时间

    // 辅助：名字
    @NSManaged public var name_my_team: String // 队名可能更改
    @NSManaged public var name_opponent_team: String // 队名可能更改
    
    // 小节，集合：， 分隔
    @NSManaged public var ids_PeriodDataOfMyTeam: String // 主队
    @NSManaged public var ids_PeriodDataOfOpponentTeam: String // 客队
    
    func output() -> String {
        var result = "\nGame Info: \n"
        result += "id: \(id)\n"
        result += "id_my_team: \(id_my_team)\n"
        result += "id_opponent_team: \(id_opponent_team)\n"
        result += "date_created: \(date_created)\n"
        result += "name_my_team: \(name_my_team)\n"
        result += "name_opponent_team: \(name_opponent_team)\n"
        result += "ids_PeriodDataOfMyTeam: \(ids_PeriodDataOfMyTeam)\n"
        result += "ids_PeriodDataOfOpponentTeam: \(ids_PeriodDataOfOpponentTeam)\n"

        return result
    }
}

/// Game
///
/// 注意事项
/// - 各个存储属性，必须有缺省值（初始化）
///
/// 数据变化与显示同步
/// - 辅助：状态变化：显示马上更新，
class GameFromViewModel: ObservableObject {
    //MARK: - 辅助：控制按钮的显示：START、STOP
    @Published var started = false

    @Published var id: Int = 0
    
    // 关联
    @Published var id_my_team: Int = 0
    @Published var id_opponent_team: Int = 0
    
    // 辅助：名字
    @Published var name_my_team: String = "" // 队名可能更改
    @Published var name_opponent_team: String = "" // 队名可能更改
    
    // 小节，集合：， 分隔
    @Published var ids_PeriodDataOfMyTeam: String = "" // 主队
    @Published var ids_PeriodDataOfOpponentTeam: String = "" // 客队
    
    //MARK: - 辅助：
    // 辅助：我方
    @Published var periodDataOfMyTeamFromViewModels: [PeriodDataOfMyTeamFromViewModel] = [PeriodDataOfMyTeamFromViewModel]()
    
    @Published var playerLiveDataFromViewModels: [PlayerLiveDataFromViewModel] = [PlayerLiveDataFromViewModel]()
    
    // 辅助：对方
    @Published var periodDataOfOpponentTeamFromViewModels: [PeriodDataOfOpponentTeamFromViewModel] = [PeriodDataOfOpponentTeamFromViewModel]()
    
    // 选中高亮的小节
    @Published var perionds_highlight: Set<Int> = [0] // 复数
    
    // PlusMinus，缺省为+1，true
    @Published var isOnPlusMinus = true
    
    var value: Int {
        if isOnPlusMinus {
            print("isOn == true")
            return 1
        } else {
            print("isOn == false")
            return -1
        }
    }
    
    // 按钮：声控，缺省为false
    @Published var isOnVoiceControl = false
    
    // 按钮：大表显示，缺省为false，不显示
    @Published var isOnZoomin = false
    
    // 按钮：上场队员替换显示，缺省为false，不显示
    @Published var isOnPlayers = false
    
    // 按钮：手动输入显示，缺省为false，不显示
    @Published var isOnManualCommand = false
    
    // 辅助
    //MARK: - 比赛进行了多长时间，计数器
    @Published var game_cum_duration: Float = 0 // 23 * 60 + 45
    
    // 辅助：状态变化：显示马上更新，
    @Published var counter_tap = 0 // 球员实时数据跟踪表
    @Published var counter_tap_subsititue = 0 // 替换球员表
    
    // 辅助
    @Published var tap_period1: Bool = false
    @Published var tap_period2: Bool = false
    @Published var tap_period3: Bool = false
    @Published var tap_period4: Bool = false
    @Published var tap_period5: Bool = false
    @Published var tap_period6: Bool = false
    @Published var tap_period7: Bool = false
    
    // 辅助
    @Published var status_Game: Int = 0 // 0:进入，尚未开始；1:开始，正在进行；2:比赛结束。

    var score_MyTeam: Int { // 计算我方得分
        var result = 0
        for periodDataOfMyTeamFromViewModel in periodDataOfMyTeamFromViewModels {
            result += periodDataOfMyTeamFromViewModel.score
        }
        
        return result
    }
    
    var score_OpponentTeam: Int { // 计算对方得分
        var result = 0
        for periodDataOfOpponentTeamFromViewModel in periodDataOfOpponentTeamFromViewModels {
            result += periodDataOfOpponentTeamFromViewModel.score
        }
        
        return result
    }
    
    init(game: Game? = nil) {
        if let game = game {
            self.id = game.id
            self.id_my_team = game.id_my_team
            self.id_opponent_team = game.id_opponent_team
            self.name_my_team = game.name_my_team
            self.name_opponent_team = game.name_opponent_team
            self.ids_PeriodDataOfMyTeam = game.ids_PeriodDataOfMyTeam
            self.ids_PeriodDataOfOpponentTeam = game.ids_PeriodDataOfOpponentTeam
            
            // 通知：统计计算
            NotificationCenter.default.addObserver(self, selector: #selector(toMake), name: .toMake, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toMiss), name: .toMiss, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toBucket), name: .toBucket, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toBrick), name: .toBrick, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toSwish), name: .toSwish, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toOff), name: .toOff, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toBoard), name: .toBoard, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toGlass), name: .toGlass, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toDime), name: .toDime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toBad), name: .toBad, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toSteal), name: .toSteal, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toBlock), name: .toBlock, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toTip), name: .toTip, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toCharge), name: .toCharge, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(toTie), name: .toTie, object: nil)
        }
    }
    
    /// 我队
    func setupMyTeam(team: Team) {
        self.id_my_team = team.id
        self.name_my_team = team.name
    }
    
    /// 对方球队
    func setupOppenengTeam(team: Team) {
        self.id_opponent_team = team.id
        self.name_opponent_team = team.name
    }
    
    // 表底：实时数据统计
    @Published var footer_total: PlayerLiveDataFromViewModel = PlayerLiveDataFromViewModel(total: "Total")
    
    /// 结束当前小节
    ///
    /// 存储当前小节的数据
    /// - 小节的结束时间
    ///
    /// 存储到数据库
    func endCurrentPeriod() {
        
    }
    
    /// 开始进行下一个小节
    ///
    /// 包括以下内容
    /// - 选中处理：仅选中下一个小节
    /// - 创建下一个小节的数据
    /// - 将下一个小节的数据传送给各个模块
    func beginNextPeriod() {
        // 1. 仅选中下一个小节
        self.perionds_highlight = [self.periodDataOfMyTeamFromViewModels.count]
        
        // 2. 创建下一个小节的数据
        self.initiateDataOfNextPeriod()
    }
    
    /// 切换到小节，小节已经结束
    ///
    /// 需要改变以下内容
    /// - 球员实时数据跟踪数据表：使用切换的小节，已经结束不能计时，可以修改数据
    func switchToEndedPeriod(index: Int) {
        // 仅包含要切换到的小节
        self.perionds_highlight = [index]
    }
    
    /// 创建下一个小节
    ///
    ///1. 小节：我方、对方
    ///2. 我方队员：队员 + 首发球员
    ///
    /// 对应ID：自增设计
    func initiateDataOfNextPeriod() {
        // 0）下一个小节的命名：P1、P2、P3、P4、O1、O2、O3
        var name_period = ""
        let count = self.periodDataOfMyTeamFromViewModels.count + 1
        if count <= 4 {
            name_period = "P" + "\(count)"
        } else {
            name_period = "O" + "\(count - 4)"
        }
        
        // 1）下一个小节的生成时间
        let date_created = Int(Date().timeIntervalSince1970) // 精确到秒

        // 2）调用PersistenceController
        let context = PersistenceController.shared.container.viewContext
        
        // 3）小节
        // 3.1）我方
        let periodDataOfMyTeam = PeriodDataOfMyTeam(context: context)
        do {
            let aint = UserDefaults.standard.integer(forKey: "id_PeriodDataOfMyTeam")
            periodDataOfMyTeam.id = aint + 1
            UserDefaults.standard.set(periodDataOfMyTeam.id, forKey: "id_PeriodDataOfMyTeam")
        }
        self.ids_PeriodDataOfMyTeam += "\(periodDataOfMyTeam.id)"

        // 3.2）对方
        let periodDataOfOpponentTeam = PeriodDataOfOpponentTeam(context: context)
        do {
            let aint = UserDefaults.standard.integer(forKey: "id_PeriodDataOfOpponentTeam")
            periodDataOfOpponentTeam.id = aint + 1
            UserDefaults.standard.set(periodDataOfOpponentTeam.id, forKey: "id_PeriodDataOfOpponentTeam")
        }
        self.ids_PeriodDataOfOpponentTeam += "\(periodDataOfOpponentTeam.id)"

        // 4）我方：periodDataOfMyTeam
        periodDataOfMyTeam.id_game = self.id
        periodDataOfMyTeam.id_my_team = self.id_my_team
        
        periodDataOfMyTeam.name_period = name_period
        
        
        periodDataOfMyTeam.score = 0
        periodDataOfMyTeam.date_created = date_created // 精确到秒
        
        // 4.1）我方： ids_PlayerLiveData、playerLiveDataFromViewModels
        var strs = ""
        
        // 4.2）如果在循环里面，会发生错误：UserDefaults
        var aint = UserDefaults.standard.integer(forKey: "id_PlayerLiveData") // 当前保存的
        
        var playerLiveDataFromViewModels = [PlayerLiveDataFromViewModel]()
        //使用上一个小节：球员
        for pldfvm in self.periodDataOfMyTeamFromViewModels.last!.playerLiveDataFromViewModels {
            aint += 1
            let pld = PlayerLiveData(context: context)
            
            pld.id = aint
            
            strs += "\(pld.id),"
            
            pld.id_game = self.id
            pld.id_my_team = self.id_my_team
            pld.id_period = periodDataOfMyTeam.id
            
            pld.id_player = pldfvm.id
            pld.name_player = pldfvm.player
            pld.number = pldfvm.number
            pld.isOnCourt = pldfvm.isOnCourt
            
            pld.time_cumulative = 0
            pld.ids_ItemLiveData = ""
            
            // 4.3）生成PlayerLiveDataFromViewModel
            let playerLiveDataFromViewModel = PlayerLiveDataFromViewModel(playerLiveData: pld)
            playerLiveDataFromViewModels.append(playerLiveDataFromViewModel)
        }
        
        // 4.4）ids_PlayerLiveData
        periodDataOfMyTeam.ids_PlayerLiveData = strs
        
        // 4.5）保存：id_PlayerLiveData
        UserDefaults.standard.set(aint, forKey: "id_PlayerLiveData") // 保存最大的

        // 测试：输出数据
        print(periodDataOfMyTeam.output())
        
        // 4.6）添加到数组
        let periodDataOfMyTeamFromViewModel = PeriodDataOfMyTeamFromViewModel(periodDataOfMyTeam: periodDataOfMyTeam)
        periodDataOfMyTeamFromViewModel.playerLiveDataFromViewModels = playerLiveDataFromViewModels
        self.periodDataOfMyTeamFromViewModels.append(periodDataOfMyTeamFromViewModel)
        
        // 5) periodDataOfOpponentTeam
        periodDataOfOpponentTeam.id_game = self.id
        periodDataOfOpponentTeam.id_opponent_team = self.id_opponent_team
        periodDataOfOpponentTeam.name_period = name_period
        periodDataOfOpponentTeam.score = 0
        periodDataOfOpponentTeam.date_created = date_created // 小节两队同一个时间

        // 测试：输出数据
        print(periodDataOfOpponentTeam.output())
        
        // 5.1）添加到数组
        let periodDataOfOpponentTeamFromViewModel = PeriodDataOfOpponentTeamFromViewModel(periodDataOfOpponentTeam: periodDataOfOpponentTeam)
        self.periodDataOfOpponentTeamFromViewModels.append(periodDataOfOpponentTeamFromViewModel)
        
        //6) 表底的统计数据：新的，各种统计数据
        self.footer_total = PlayerLiveDataFromViewModel(total: "Total")
        
        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
    
}





