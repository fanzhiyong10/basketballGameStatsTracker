//
//  Player.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/18.
//

import CoreData

public class Player: NSManagedObject {
    @NSManaged public var id: Int
    @NSManaged public var fullName: String
    @NSManaged public var name: String
    @NSManaged public var number: String
    
    func output() -> String {
        var result = "\nPlayer Info: \n"
        result += "id: \(id)\n"
        result += "name: \(name)\n"
        result += "fullName: \(fullName)\n"
        result += "number: \(number)\n"

        return result
    }
}

///选择上场球员
///
///功能要求
///- 点击行，改变属性isOnCourt（Bool类型），若未选择，则选择True；若已选择，则改为未选择False
///
///技术
///- 需要跟踪变化的属性，打上标签 @Published
class PlayerFromViewModel: ObservableObject {
    @Published var id: Int = 0
    @Published var fullName : String = ""
    @Published var name : String = ""
    @Published var number : String = ""
    
    // 辅助：选择上场球员，@Published，变化时则通知
    @Published var isOnCourt : Bool = false

    // 辅助：选择上场球员，点击行，提示上场球员的人数。@Published，变化时则通知
    @Published var showAlert : Bool = false

    init(player: Player? = nil) {
        if let player = player {
            self.id = player.id
            self.fullName = player.fullName
            self.name = player.name
            self.number = player.number
        }
    }
}

