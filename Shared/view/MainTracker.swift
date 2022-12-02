//
//  MainTracker.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/11.
//

import SwiftUI

///主页面
///
///技巧
/// - 隐藏导航栏区域，该区域的对象会响应设定的事件
struct MainTracker: View {
    
    //MARK: - 全局环境变量 状态控制
    @EnvironmentObject var mainStates: MainStateControl
    
    //MARK: -  我队的比赛数据 1.必须确保生成
    @Binding var liveDatas : [LiveData]

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TopAreaView(liveDatas: $liveDatas)
                .frame(height: 130, alignment: .topLeading)
                .background(Color.init(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0))
            
            PlayerLiveDataTable(liveDatas: $liveDatas)
                .ignoresSafeArea()
                .overlay(alignment: .topLeading) {
                    if self.mainStates.isOnZoomin {
                        // 场上队员表：放大显示
                        VStack(spacing: 0) {
                            OnCourtPlayerLiveDataTable(liveDatas: $liveDatas)

                            // 白色填充，不让背后的表露出了
                            Color.white
                                .frame(height: 100)
                        }
                        
                    }
                }
                .overlay(alignment: .center) {
                    if self.mainStates.isOnPlayers {
                        PlayersTable(liveDatas: $liveDatas)
                    }
                }
        }
        .ignoresSafeArea() // 忽略
        .navigationBarHidden(true) // 隐藏导航栏区域，该区域的对象会响应设定的事件
    }
}

struct MainTracker_Previews: PreviewProvider {
    static var previews: some View {
        MainTracker(liveDatas: .constant(LiveData.createData()))
            .environmentObject(MainStateControl())
            .environmentObject(MyTeamInfo())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
