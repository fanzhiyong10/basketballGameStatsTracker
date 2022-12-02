//
//  TopAreaView.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/12.
//

import SwiftUI

struct TopAreaView: View {
    
    //MARK: - 全局环境变量 状态控制
    @EnvironmentObject var mainStates: MainStateControl

    //MARK: -  我队的比赛数据 1.必须确保生成
    @Binding var liveDatas : [LiveData]

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: "mic.circle.fill")
                .resizable()
                .padding(.leading, 12)
                .padding(.top, 55)
                .frame(width: 72, height: 115, alignment: .center)
                .foregroundColor(self.mainStates.isOnVoiceControl ? .green : .gray)
                .onTapGesture {
                    print("mic.circle.fill")
                    self.mainStates.isOnVoiceControl.toggle()
                }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\"Ben Make\"")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.leading, -60)
                
                PlusMinusToggle()
                    .padding(.leading, 20)
                
                Text("Manual Command")
                    .font(.title3)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        print("Manual Command")
                    }
            }
            
            Spacer()
            
            GameClockView(liveDatas: $liveDatas)
                .padding(.top, 8)

            Spacer()
            
            TeamPeriodScoreTable()
                .frame(width: 500, height: 120, alignment: .topLeading)
            
            OpponentScoreStepper()
                .padding(.top, 8)
                .padding(.trailing, 20)
        }
    }
    
    private func toPlus() {
        print("plus_minus = 1")
//        self.plus_minus = 1
    }
}

struct TopAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TopAreaView(liveDatas: .constant(LiveData.createData()))
            .environmentObject(MainStateControl())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
