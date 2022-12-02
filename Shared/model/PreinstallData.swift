//
//  PreinstallData.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/27.
//

//import Foundation
import SwiftUI
import CoreData

///预装数据
class PreinstallData {
    init() {
        print("预装数据")
        installPlayers()
        installTeams()
    }
    
    /// 预装球队数据
    func installTeams() {
        // 如果已有球员数据，则不预装，否则预装
        
        //已经存储的数据
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        if let teams = try? PersistenceController.shared.container.viewContext.fetch(fetchRequest) as? [Team], teams.count > 0 {
            for team in teams {
                print("team.name : \(team.name)")
            }
        } else {
            // 预装数据
            loadTeams()
        }
    }
    
    /// 加载球队数据
    func loadTeams() {
        // 关键1：PersistenceController.shared
        let viewContext = PersistenceController.shared.container.viewContext
        
        // 球队：主队
        do {
            let team = Team(context: viewContext)
            team.name = "My Team"
            team.fullName = "My Team Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_Team")
            team.id = aint + 1
            UserDefaults.standard.set(team.id, forKey: "id_Team")
            
            var str = ""
            for index in 1...17 {
                str += "\(index),"
            }
            print(str)
            team.ids_player = str
        }
        
        // 球队：对手
        do {
            let team = Team(context: viewContext)
            team.name = "Opponent"
            team.fullName = "Opponent Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_Team")
            team.id = aint + 1
            UserDefaults.standard.set(team.id, forKey: "id_Team")
        }

        /*
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        */
    }
    
    /// 预装球员数据
    func installPlayers() {
        // 如果已有球员数据，则不预装，否则预装
        
        //已经存储的数据
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        if let players = try? PersistenceController.shared.container.viewContext.fetch(fetchRequest) as? [Player], players.count > 0 {
            for player in players {
                print("player.fullName : \(player.fullName)")
            }
        } else {
            // 预装数据
            loadPlayers()
        }
    }
    
    /// 预装数据
    func loadPlayers() {
        // 关键1：PersistenceController.shared
        let viewContext = PersistenceController.shared.container.viewContext
        
        // 队员
        do {
            let player = Player(context: viewContext)
            player.name = "Aaron"
            player.number = "99"
            player.fullName = "Aaron Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Ben"
            player.number = "23"
            player.fullName = "Ben Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Blas"
            player.number = "88"
            player.fullName = "Blas Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Bryson"
            player.number = "83"
            player.fullName = "Bryson Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Caleb"
            player.number = "84"
            player.fullName = "Caleb Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Dante"
            player.number = "22"
            player.fullName = "Dante Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Dusty"
            player.number = "34"
            player.fullName = "Dusty Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Ethan"
            player.number = "98"
            player.fullName = "Ethan Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Jayden"
            player.number = "66"
            player.fullName = "Jayden Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Jerrod"
            player.number = "55"
            player.fullName = "Jerrod Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Logan"
            player.number = "54"
            player.fullName = "Logan Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Lucas"
            player.number = "32"
            player.fullName = "Lucas Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Luka"
            player.number = "77"
            player.fullName = "Luka Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Matthew"
            player.number = "62"
            player.fullName = "Matthew Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Reid"
            player.number = "11"
            player.fullName = "Reid Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Sam"
            player.number = "96"
            player.fullName = "Sam Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            let player = Player(context: viewContext)
            player.name = "Tyler"
            player.number = "76"
            player.fullName = "Tyler Full"
            
            // id
            let aint = UserDefaults.standard.integer(forKey: "id_player")
            player.id = aint + 1
            UserDefaults.standard.set(player.id, forKey: "id_player")
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
