//
//  PeriodDataOfMyTeam.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/2.
//


import CoreData

/// 小节数据：我方
///
/// 注意
/// - 第一节，首发5个球员，需要初始化
public class PeriodDataOfMyTeam: NSManagedObject {
    @NSManaged public var id: Int // id_PeriodDataOfMyTeam
    
    // 关联
    @NSManaged public var id_game: Int
    @NSManaged public var id_my_team: Int
    
    // 属性
    @NSManaged public var name_period: String
    @NSManaged public var score: Int // 计算
    
    // 集合：， 分隔，包含小节：正在比赛的、比赛结束的。
    @NSManaged public var ids_PlayerLiveData: String
    
    // 时间
    // 小节生成时间
    @NSManaged public var date_created: Int
    
    // 小节开始时间
    @NSManaged public var date_begin: Int
    
    // 小节结束时间
    @NSManaged public var date_end: Int
    
    func output() -> String {
        var result = "\nPeriodDataOfMyTeam Info: \n"
        result += "id: \(id)\n"
        result += "id_game: \(id_game)\n"
        result += "id_my_team: \(id_my_team)\n"
        result += "name_period: \(name_period)\n"
        result += "score: \(score)\n"
        result += "ids_PlayerLiveData: \(ids_PlayerLiveData)\n"
        result += "date_created: \(date_created)\n"
        result += "date_begin: \(date_begin)\n"
        result += "date_end: \(date_end)\n"

        return result
    }
    
}

///主队某个小节的数据，用于显示
class PeriodDataOfMyTeamFromViewModel: ObservableObject {
    @Published var id: Int = 0 // id_PeriodDataOfMyTeam
    
    // 关联
    @Published var id_game: Int = 0
    @Published public var id_my_team: Int = 0
    
    // 属性
    @Published public var name_period: String = ""
    var score: Int { // 计算各个球员的得分
        var result = 0
        for playerLiveDataFromViewModel in playerLiveDataFromViewModels {
            result += playerLiveDataFromViewModel.points_cal
        }
        return result
    }
    
    // 集合：， 分隔，包含小节：正在比赛的、比赛结束的。
    @Published var ids_PlayerLiveData: String = ""
    
    // 时间
    // 小节生成时间
    @Published var date_created: Int = 0
    
    // 小节开始时间
    @Published var date_begin: Int = 0
    
    // 小节结束时间
    @Published var date_end: Int = 0
    
    // 辅助：球员
    @Published var playerLiveDataFromViewModels: [PlayerLiveDataFromViewModel] = [PlayerLiveDataFromViewModel]()
    
    // 辅助：表底：实时数据统计
    @Published var footer_total: PlayerLiveDataFromViewModel = PlayerLiveDataFromViewModel(total: "Total")

    init(periodDataOfMyTeam: PeriodDataOfMyTeam? = nil) {
        if let periodDataOfMyTeam = periodDataOfMyTeam {
            self.id = periodDataOfMyTeam.id
            self.id_game = periodDataOfMyTeam.id_game
            self.id_my_team = periodDataOfMyTeam.id_my_team
            self.name_period = periodDataOfMyTeam.name_period
//            self.score = periodDataOfMyTeam.score
            self.ids_PlayerLiveData = periodDataOfMyTeam.ids_PlayerLiveData
            self.date_created = periodDataOfMyTeam.date_created
            self.date_begin = periodDataOfMyTeam.date_begin
            self.date_end = periodDataOfMyTeam.date_end
        }
    }

}

/// 小节数据：对手
public class PeriodDataOfOpponentTeam: NSManagedObject {
    @NSManaged public var id: Int
    
    // 关联
    @NSManaged public var id_game: Int
    @NSManaged public var id_opponent_team: Int
    
    // 属性
    @NSManaged public var name_period: String // 小节名，P1,P2,P3,P4,O1,O2,O3
    @NSManaged public var score: Int // 输入
    
    // 时间
    // 小节生成时间
    @NSManaged public var date_created: Int
    
    // 小节开始时间
    @NSManaged public var date_begin: Int
    
    // 小节结束时间
    @NSManaged public var date_end: Int
    
    func output() -> String {
        var result = "\nPeriodDataOfOpponentTeam Info: \n"
        result += "id: \(id)\n"
        result += "id_game: \(id_game)\n"
        result += "id_opponent_team: \(id_opponent_team)\n"
        result += "name_period: \(name_period)\n"
        result += "score: \(score)\n"
        result += "date_created: \(date_created)\n"
        result += "date_begin: \(date_begin)\n"
        result += "date_end: \(date_end)\n"

        return result
    }
    
}

class PeriodDataOfOpponentTeamFromViewModel: ObservableObject {
    @Published var id: Int = 0 // id_PeriodDataOfOpponentTeam
    
    // 关联
    @Published var id_game: Int = 0
    @Published var id_opponent_team: Int = 0
    
    // 属性
    @Published var name_period: String = "" // 小节名，P1,P2,P3,P4,O1,O2,O3
    @Published var score: Int = 0 // 输入
    
    // 时间：方便查询
    // 小节生成时间
    @Published var date_created: Int = 0
    
    // 小节开始时间
    @Published var date_begin: Int = 0
    
    // 小节结束时间
    @Published var date_end: Int = 0
    
    init(periodDataOfOpponentTeam: PeriodDataOfOpponentTeam? = nil) {
        if let periodDataOfOpponentTeam = periodDataOfOpponentTeam {
            self.id = periodDataOfOpponentTeam.id
            self.id_game = periodDataOfOpponentTeam.id_game
            self.id_opponent_team = periodDataOfOpponentTeam.id_opponent_team
            self.name_period = periodDataOfOpponentTeam.name_period
            self.score = periodDataOfOpponentTeam.score
            self.date_created = periodDataOfOpponentTeam.date_created
            self.date_begin = periodDataOfOpponentTeam.date_begin
            self.date_end = periodDataOfOpponentTeam.date_end
        }
    }
}
