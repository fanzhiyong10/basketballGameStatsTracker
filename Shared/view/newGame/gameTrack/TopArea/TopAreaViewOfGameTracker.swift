//
//  TopAreaViewOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/29.
//

import SwiftUI

struct TopAreaViewOfGameTracker: View {
    
    //MARK: - 全局环境变量 状态控制
//    @EnvironmentObject var mainStates: MainStateControl

    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: "mic.circle.fill")
                .resizable()
                .padding(.leading, 12)
                .padding(.top, 55)
                .frame(width: 72, height: 115, alignment: .center)
                .foregroundColor(self.gameFromViewModel.isOnVoiceControl ? .green : .gray)
                .onTapGesture {
                    print("mic.circle.fill")
                    self.gameFromViewModel.isOnVoiceControl.toggle()
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\"Ben Make\"")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.leading, -20)
                
                PlusMinusToggleOfGameTracker(gameFromViewModel: gameFromViewModel)
                    .padding(.leading, 20)
                
                Text("Manual Command")
                    .font(.title3)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        print("Manual Command")
                    }
            }
            
            Spacer()
            
            GameClockViewOfGameTracker(gameFromViewModel: gameFromViewModel)
                .padding(.top, 8)

            Spacer()
             
            // 两队小节得分表
            TeamPeriodScoreTableOfGameTracker(gameFromViewModel: gameFromViewModel)
                .frame(width: 500, height: 120, alignment: .topLeading)
            
            // 对方计分
            OpponentScoreStepperOfGameTracker(gameFromViewModel: gameFromViewModel)
                .padding(.top, 8)
                .padding(.trailing, 20)
            
        }
    }
    
    private func toPlus() {
        print("plus_minus = 1")
//        self.plus_minus = 1
    }
}

struct TopAreaViewOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        TopAreaViewOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
