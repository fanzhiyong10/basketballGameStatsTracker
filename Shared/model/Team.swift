//
//  Team.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/19.
//

import CoreData

/// 球队
///
/// 测试技术
/// - ids_player: 空值测试
/// - 如果可以为空值，则主队和客队，可以用同一个类；否则，区分对待
public class Team: NSManagedObject {
    @NSManaged public var id: Int // id_Team
    @NSManaged public var fullName: String
    @NSManaged public var name: String
    
    // 球员，集合：， 分隔
    @NSManaged public var ids_player: String
}

extension Team {
    /// 计算集合：球队包含的球员
    func calSetOfPlayer() -> Set<Int> {
        var selectedPlayers = Set<Int>()
        
        let str = ids_player
        
        print(str)
        
        selectedPlayers = Set<Int>()
        
        let arrs = str.split(separator: ",")
        for item in arrs {
            if let aInt = Int(item) {
                selectedPlayers.insert(aInt)
            }
        }
        return selectedPlayers
    }
}

class TeamFromViewModel: ObservableObject {
    @Published var id: Int = 0
    @Published var fullName : String = ""
    @Published var name : String = ""
    @Published var ids_player : String = ""
    
    // 关键：用于添加删除球员
    @Published var selectedPlayers = Set<Int>()

    init(team: Team? = nil) {
        if let team = team {
            self.id = team.id
            self.fullName = team.fullName
            self.name = team.name
            self.ids_player = team.ids_player
        }
    }
}

/// 用于添加删除球员，另外一种解决思路
class TeamIncludePlayers: ObservableObject {
    @Published var selectedPlayers = Set<Int>()
}
