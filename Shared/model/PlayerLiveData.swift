//
//  PlayerLiveData.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/28.
//

import CoreData

/// 某个球员实时数据
public class PlayerLiveData: NSManagedObject {
    @NSManaged public var id: Int // id_PlayerLiveData
    
    // 关联
    @NSManaged public var id_game: Int // 比赛
    @NSManaged public var id_my_team: Int // 我队
    @NSManaged public var id_period: Int // 小节
    @NSManaged public var id_player: Int // 球员
    
    // 队员属性
    @NSManaged public var name_player: String //球员名称-简称
    @NSManaged public var number: String // 球员号码
    
    // 实时数据
    // 实时状态：场上时间
    @NSManaged public var isOnCourt: Bool
    @NSManaged public var time_cumulative: Float
    
    // 各项数据
    // 集合：， 分隔
    @NSManaged public var ids_ItemLiveData: String
    
    func output() -> String {
        var result = "\nPlayerLiveData Info: \n"
        result += "id: \(id)\n"
        result += "id_game: \(id_game)\n"
        result += "id_my_team: \(id_my_team)\n"
        result += "id_period: \(id_period)\n"
        result += "id_player: \(id_player)\n"
        result += "name_player: \(name_player)\n"
        result += "number: \(number)\n"
        result += "isOnCourt: \(isOnCourt)\n"
        result += "time_cumulative: \(time_cumulative)\n"
        result += "ids_ItemLiveData: \(ids_ItemLiveData)\n"

        return result
    }
}


/// 球员实时数据
public class ItemLiveData: NSManagedObject {
    @NSManaged public var id: Int //id_ItemLiveData
    
    // 关联
    @NSManaged public var id_PlayerLiveData: Int // 比赛
    
    // 属性
    @NSManaged public var name: String // 球员号码
    @NSManaged public var date: Int // 时间发生的时间
}

///某个球员的数据，用于显示
///
///说明
///- 显示可以是单个小节，可以是多个小节
///- 多个小节，只能显示，不能修改数据。显示的数据是多个小节的统计数据。
///- 单个小节，可以修改数据。
///- 比赛中，比赛后。
///- 正在比赛小节的场上队员计时
///
///比赛中
///- 点击后续小节，提示：前面的小节正在比赛中，点击后续小节无效。
///
///第一步：新比赛：初始数据
///- 生成第一小节
///- 小节为1，第一节
///- 上场球员
///
///第二步：进入第二节
///- 点击小节1，提示：1）小节1结束，进入第二小节。
///
///第三步：进入第三节（后续小节）
///- 点击小节2（当前进行的小节），提示：1）小节2（当前进行的小节）结束，进入小节3（后续小节）。
///
///第四步：结束比赛
///- 点击当前进行的小节，提示：结束比赛
class PlayerLiveDataFromViewModel: ObservableObject {
    // 等于：PlayerLiveData的id
    @Published var id: Int = 0 // id_PlayerLiveData，唯一值（自增）
    
    @Published var id_period: Int = 0 // 小节
    @Published var id_player: Int = 0 // 球员
    @Published var player : String = ""
    @Published var number : String = ""
    
    var minutes: String {
        let mins = Int(time_cumulative / 60)
        let secs = Int(time_cumulative) - mins * 60
        let str = "\(mins):" + String(format: "%02d", secs)
        return str
    }
    @Published var time_cumulative: Float = 0
    
    @Published var ids_ItemLiveData: String = ""

    init(playerLiveData: PlayerLiveData? = nil) {
        if let playerLiveData = playerLiveData {
            self.id = playerLiveData.id
            self.id_period = playerLiveData.id_period
            self.id_player = playerLiveData.id_player
            self.player = playerLiveData.name_player
            self.number = playerLiveData.number
            
            // 上场
            self.isOnCourt = playerLiveData.isOnCourt
            self.isOnCourt_backup = playerLiveData.isOnCourt // 辅助
            
            self.time_cumulative = playerLiveData.time_cumulative
            self.ids_ItemLiveData = playerLiveData.ids_ItemLiveData
        }
    }
    
    init(total: String) {
        self.player = "Total"
        
    }
    
    init(pldfvm: PlayerLiveDataFromViewModel) {
        self.id = pldfvm.id
        self.id_period = pldfvm.id_period
        self.id_player = pldfvm.id_player
        self.player = pldfvm.player
        self.number = pldfvm.number
        self.time_cumulative = pldfvm.time_cumulative
        self.ids_ItemLiveData = pldfvm.ids_ItemLiveData
        
        self.ft_make_count = pldfvm.ft_make_count
        self.ft_miss_count = pldfvm.ft_miss_count
        self.fg2_make_count = pldfvm.fg2_make_count
        self.fg2_miss_count = pldfvm.fg2_miss_count
        self.fg3_make_count = pldfvm.fg3_make_count
        self.fg3_miss_count = pldfvm.fg3_miss_count
        self.assts_count = pldfvm.assts_count
        self.orebs_count = pldfvm.orebs_count
        self.drebs_count = pldfvm.drebs_count
        self.steals_count = pldfvm.steals_count
        self.blocks_count = pldfvm.blocks_count
        self.ties_count = pldfvm.ties_count
        self.defs_count = pldfvm.defs_count
        self.charges_count = pldfvm.charges_count
        self.tos_count = pldfvm.tos_count
    }
    
    func cleanData() {
        self.time_cumulative = 0
        self.ids_ItemLiveData = ""
        
        self.ft_make_count = 0
        self.ft_miss_count = 0
        self.fg2_make_count = 0
        self.fg2_miss_count = 0
        self.fg3_make_count = 0
        self.fg3_miss_count = 0
        self.assts_count = 0
        self.orebs_count = 0
        self.drebs_count = 0
        self.steals_count = 0
        self.blocks_count = 0
        self.ties_count = 0
        self.defs_count = 0
        self.charges_count = 0
        self.tos_count = 0
    }
    
    // 合并数据
    func unionPlayer(pldfvm: PlayerLiveDataFromViewModel) {
        self.time_cumulative += pldfvm.time_cumulative
        self.ids_ItemLiveData += pldfvm.ids_ItemLiveData
        
        self.ft_make_count += pldfvm.ft_make_count
        self.ft_miss_count += pldfvm.ft_miss_count
        self.fg2_make_count += pldfvm.fg2_make_count
        self.fg2_miss_count += pldfvm.fg2_miss_count
        self.fg3_make_count += pldfvm.fg3_make_count
        self.fg3_miss_count += pldfvm.fg3_miss_count
        self.assts_count += pldfvm.assts_count
        self.orebs_count += pldfvm.orebs_count
        self.drebs_count += pldfvm.drebs_count
        self.steals_count += pldfvm.steals_count
        self.blocks_count += pldfvm.blocks_count
        self.ties_count += pldfvm.ties_count
        self.defs_count += pldfvm.defs_count
        self.charges_count += pldfvm.charges_count
        self.tos_count += pldfvm.tos_count
    }
    
    func addItemLiveData(item: ItemLiveData) {
        switch item.name {
        case "ft_make":
            self.ft_make_count += 1
            
        case "ft_miss":
            self.ft_miss_count += 1
            
        case "fg2_make":
            self.fg2_make_count += 1
            
        case "fg2_miss":
            self.fg2_miss_count += 1
            
        case "fg3_make":
            self.fg3_make_count += 1
            
        case "fg3_miss":
            self.fg3_miss_count += 1
            
        case "assts":
            self.assts_count += 1
            
        case "orebs":
            self.orebs_count += 1
            
        case "drebs":
            self.drebs_count += 1
            
        case "steals":
            self.steals_count += 1
            
        case "blocks":
            self.blocks_count += 1
            
        case "ties":
            self.ties_count += 1
            
        case "defs":
            self.defs_count += 1
            
        case "charges":
            self.charges_count += 1
            
        case "tos":
            self.tos_count += 1

        default:
            break
        }
    }
    
    var per: String {
        let str = "\(self.per_cal)"
        return str
    }
    var per_cal: Int {
        var pc = self.points_cal
        pc -= ft_miss_count + fg2_miss_count + fg3_miss_count
        pc += assts_count + orebs_count + drebs_count + steals_count + blocks_count + ties_count + defs_count + charges_count * 2
        pc -= tos_count * 2
        return pc
    }
    
    var points: String {
        let str = "\(self.points_cal)"
        return str
    }
    var points_cal: Int {
        var pc = self.ft_make_count
        pc += fg2_make_count * 2
        pc += fg3_make_count * 3
        return pc
    }
    
    var ft: String {
        let total = self.ft_make_count + self.ft_miss_count
        
        if total == 0 {
            return "0/0\n(--%)"
        }
        
        let percent = Float(self.ft_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent)
        let str = "\(self.ft_make_count)/\(total)" + "\n(" + formatted + "%)"
        
        return str
    }
    
    var ft_percent_csv: String {
        let total = self.ft_make_count + self.ft_miss_count
        
        if total == 0 {
            return "--%"
        }
        
        let percent = Float(self.ft_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent) + "%"
        let str = formatted
        
        return str
    }
    
    var ft_csv: String {
        let total = self.ft_make_count + self.ft_miss_count
        
        let str = "\(self.ft_make_count)/\(total)"
        
        return str
    }
    
    @Published var ft_make_count: Int = 0
    @Published var ft_miss_count: Int = 0
    
    var fg2: String {
        let total = self.fg2_make_count + self.fg2_miss_count
        
        if total == 0 {
            return "0/0\n(--%)"
        }
        
        let percent = Float(self.fg2_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent)
        let str = "\(self.fg2_make_count)/\(total)" + "\n(" + formatted + "%)"
        
        return str
    }
    var fg2_percent_csv: String {
        let total = self.fg2_make_count + self.fg2_miss_count
        
        if total == 0 {
            return "--%"
        }
        
        let percent = Float(self.fg2_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent) + "%"
        let str = formatted
        
        return str
    }
    
    var fg2_csv: String {
        let total = self.fg2_make_count + self.fg2_miss_count
        
        let str = "\(self.fg2_make_count)/\(total)"
        
        return str
    }
    @Published var fg2_make_count: Int = 0
    @Published var fg2_miss_count: Int = 0
    
    var fg3: String {
        let total = self.fg3_make_count + self.fg3_miss_count
        
        if total == 0 {
            return "0/0\n(--%)"
        }
        
        let percent = Float(self.fg3_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent)
        let str = "\(self.fg3_make_count)/\(total)" + "\n(" + formatted + "%)"
        
        return str
    }
    
    var fg3_percent_csv: String {
        let total = self.fg3_make_count + self.fg3_miss_count
        
        if total == 0 {
            return "--%"
        }
        
        let percent = Float(self.fg3_make_count) / Float(total) * 100
        let formatted = String(format: "%.1f", percent) + "%"
        let str = formatted
        
        return str
    }
    
    var fg3_csv: String {
        let total = self.fg3_make_count + self.fg3_miss_count
        
        let str = "\(self.fg3_make_count)/\(total)"
        
        return str
    }
    @Published var fg3_make_count: Int = 0
    @Published var fg3_miss_count: Int = 0
    
    var eFG: String {
        guard let eFG_cal = self.eFG_cal else {
            return "--%"
        }
            
        let percent = eFG_cal * 100
        let formatted = String(format: "%.1f", percent)
        let str = formatted + "%"
        
        return str
    }
    var eFG_cal: Float? {
        let total = Float(fg2_make_count + fg2_miss_count + fg3_make_count + fg3_miss_count)
        if total <= 0 {
            return nil
        }
        var result: Float = Float(fg2_make_count)
        result += Float(fg3_make_count) * 1.5
        result /= Float(fg2_make_count + fg2_miss_count + fg3_make_count + fg3_miss_count)
        return result
    }
    
    var assts: String {
        let str = "\(self.assts_count)"
        return str
    }
    @Published var assts_count: Int = 0
    
    var orebs: String {
        let str = "\(self.orebs_count)"
        return str
    }
    @Published var orebs_count: Int = 0
    
    var drebs: String {
        let str = "\(self.drebs_count)"
        return str
    }
    @Published var drebs_count: Int = 0
    
    var steals: String {
        let str = "\(self.steals_count)"
        return str
    }
    @Published var steals_count: Int = 0
    
    var blocks: String {
        let str = "\(self.blocks_count)"
        return str
    }
    @Published var blocks_count: Int = 0
    
    var ties: String {
        let str = "\(self.ties_count)"
        return str
    }
    @Published var ties_count: Int = 0
    
    var defs: String {
        let str = "\(self.defs_count)"
        return str
    }
    @Published var defs_count: Int = 0
    
    var charges: String {
        let str = "\(self.charges_count)"
        return str
    }
    @Published var charges_count: Int = 0
    
    var tos: String {
        let str = "\(self.tos_count)"
        return str
    }
    @Published var tos_count: Int = 0
    
    @Published var isOnCourt = false
    
    // 辅助
    @Published var isOnCourt_backup = false
}
