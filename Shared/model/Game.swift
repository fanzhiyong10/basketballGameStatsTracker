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
    @Published var periond_highlight: [Int] = [0]
    
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
    
    // 我队
    func setupMyTeam(team: Team) {
        self.id_my_team = team.id
        self.name_my_team = team.name
    }
    
    // 对方球队
    func setupOppenengTeam(team: Team) {
        self.id_opponent_team = team.id
        self.name_opponent_team = team.name
    }
    
    // 表底：实时数据统计
    @Published var footer_total: PlayerLiveDataFromViewModel = PlayerLiveDataFromViewModel(total: "Total")
    
    // 统计计算：ft_make_count
    @objc func toMake() {
//        footer_total.ft_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ft_make_count
        }
        footer_total.ft_make_count = result
    }
    
    // 统计计算：ft_miss_count
    @objc func toMiss() {
//        footer_total.ft_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ft_miss_count
        }
        footer_total.ft_miss_count = result
    }
    
    // 统计计算：fg2_make_count
    @objc func toBucket() {
//        footer_total.fg2_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg2_make_count
        }
        footer_total.fg2_make_count = result
    }
    
    // 统计计算：fg2_miss_count
    @objc func toBrick() {
//        footer_total.fg2_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg2_miss_count
        }
        footer_total.fg2_miss_count = result
    }
    
    // 统计计算：fg3_make_count
    @objc func toSwish() {
//        footer_total.fg3_make_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg3_make_count
        }
        footer_total.fg3_make_count = result
    }
    
    // 统计计算：fg3_miss_count
    @objc func toOff() {
//        footer_total.fg3_miss_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.fg3_miss_count
        }
        footer_total.fg3_miss_count = result
    }
    
    // 统计计算：orebs_count
    @objc func toBoard() {
//        footer_total.orebs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.orebs_count
        }
        footer_total.orebs_count = result
    }
    
    // 统计计算：drebs_count
    @objc func toGlass() {
//        footer_total.drebs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.drebs_count
        }
        footer_total.drebs_count = result
    }
    
    // 统计计算：assts_count
    @objc func toDime() {
//        footer_total.assts_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.assts_count
        }
        footer_total.assts_count = result
    }
    
    // 统计计算：tos_count
    @objc func toBad() {
//        footer_total.tos_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.tos_count
        }
        footer_total.tos_count = result
    }
    
    // 统计计算：steals_count
    @objc func toSteal() {
//        footer_total.steals_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.steals_count
        }
        footer_total.steals_count = result
    }
    
    // 统计计算：blocks_count
    @objc func toBlock() {
//        footer_total.blocks_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.blocks_count
        }
        footer_total.blocks_count = result
    }
    
    // 统计计算：defs_count
    @objc func toTip() {
//        footer_total.defs_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.defs_count
        }
        footer_total.defs_count = result
    }
    
    // 统计计算：charges_count
    @objc func toCharge() {
//        footer_total.charges_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.charges_count
        }
        footer_total.charges_count = result
    }
    
    // 统计计算：ties_count
    @objc func toTie() {
//        footer_total.ties_count += 1
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.ties_count
        }
        footer_total.ties_count = result
    }
    
}

extension Notification.Name {
    static let commandSuccess = Notification.Name("commandSuccess")
    static let toMake = Notification.Name("toMake") // ft_make_count
    static let toMiss = Notification.Name("toMiss") // ft_miss_count
    static let toBucket = Notification.Name("toBucket") // fg2_make_count
    static let toBrick = Notification.Name("toBrick") // fg2_miss_count
    static let toSwish = Notification.Name("toSwish") // fg3_make_count
    static let toOff = Notification.Name("toOff") // fg3_miss_count
    static let toDime = Notification.Name("toDime") // assts_count
    static let toBoard = Notification.Name("toBoard") // orebs_count
    static let toGlass = Notification.Name("toGlass") // drebs_count
    static let toSteal = Notification.Name("toSteal") // steals_count
    static let toBlock = Notification.Name("toBlock") // blocks_count
    static let toTie = Notification.Name("toTie") // ties_count
    static let toTip = Notification.Name("toTip") // defs_count
    static let toCharge = Notification.Name("toCharge") // charges_count
    static let toBad = Notification.Name("toBad") // tos_count
}



