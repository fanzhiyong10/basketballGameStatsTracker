//
//  PlusMinusToggleOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

///比赛实时跟踪场景下：点击响应：是＋还是－
struct PlusMinusToggleOfGameTracker: View {
    //MARK: - 比赛实时跟踪场景下：＋还是－
    @ObservedObject var gameFromViewModel: GameFromViewModel

    init(gameFromViewModel: GameFromViewModel) {
        self.gameFromViewModel = gameFromViewModel
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Toggle(isOn: $gameFromViewModel.isOnPlusMinus) {
                Text("-")
                    .font(.largeTitle)
                    .onTapGesture {
                        gameFromViewModel.isOnPlusMinus = false
                    }
            }
                .toggleStyle(.switch)
            
            Spacer()
            
            Text("+")
                .font(.largeTitle)
                .onTapGesture {
                    gameFromViewModel.isOnPlusMinus = true
                }
        }
        .frame(width: 100, height: 50)
    }
}

struct PlusMinusToggleOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        PlusMinusToggleOfGameTracker(gameFromViewModel: GameFromViewModel())
    }
}
