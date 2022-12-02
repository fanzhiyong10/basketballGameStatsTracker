//
//  basketballGameStatsTrackerApp.swift
//  Shared
//
//  Created by 范志勇 on 2022/11/18.
//

import SwiftUI

@main
struct basketballGameStatsTrackerApp: App {
    let persistenceController = PersistenceController.shared

    //MARK: -  全局环境变量 1.必须确保生成
    @StateObject var mainStates = MainStateControl()

    //MARK: -  我队的比赛数据 1.必须确保生成
    @StateObject var myTeamInfo = MyTeamInfo()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainStates)
                .environmentObject(myTeamInfo)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
//            ContentViewMain()
        }
    }
}
