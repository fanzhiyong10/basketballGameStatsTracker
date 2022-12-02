//
//  GamePlay.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/29.
//

import SwiftUI

/// 入口：新比赛，选择双方球队，我方首发球员，开始比赛
///
/// 初始化
struct GamePlay: View {
    //MARK: - 全局环境变量 项目创建时，自动生成
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - 左侧菜单
    private var items_menu: [String] = ["New Game", "Share", "Voice Training", "Team Info", "Players"]
    
    //MARK: - 全局环境变量 状态控制，声明
//    @EnvironmentObject var mainStates: MainStateControl
    @StateObject var mainStates = MainStateControl()

    var body: some View {
        NavigationView {
            List {
                ForEach(items_menu.indices, id: \.self) { index in
                    NavigationLink {
                        switch index {
                        case 0 :
                            // New Game
                            // 新比赛
//                            SelectTeam()
                            Text(items_menu[index])

                        case 1 :
                            // Share
                            Text(items_menu[index])
                            
                        case 2 :
                            // Voice Training
                            Text(items_menu[index])
                            
                        case 3 :
                            // Teams
                            TeamsListView()
                            
                        case 4 :
                            // Players
                            PlayersListView()
                            
                        default :
                            // 主页面
                            Text(items_menu[index])
                        }
                        
                    } label: {
                        Text(items_menu[index])
                    }
                }
            }
            .navigationTitle(Text("Game Tracker"))

            // 比赛的场景：跟踪
            GameTracker()
        }
    }
}

struct GamePlay_Previews: PreviewProvider {
    static var previews: some View {
        GamePlay()
    }
}
