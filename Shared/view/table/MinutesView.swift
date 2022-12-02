//
//  MinutesView.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/20.
//

import SwiftUI
/*
struct MinutesView: View {
    
    @Binding var liveData: LiveData
    var width: CGFloat = 0
    var height: CGFloat = 0
    var fontSize: CGFloat = 0

    init(liveData: LiveData, width: CGFloat, height: CGFloat, fontSize: CGFloat) {
        self.liveData = liveData
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(liveData.minutes)
            .frame(width: width, alignment: .center)
            .font(.system(size: fontSize))
            .overlay(alignment: .trailing) {
                Color.white.frame(width: 1, height: height, alignment: .trailing)
            }
            .onReceive(NotificationCenter.default.publisher(for: .time_count)) { _ in
                if liveData.isOnCourt {
                    liveData.time_cumulative += 1
                }
            }
    }
}
*/
/*
struct MinutesView_Previews: PreviewProvider {
    static var previews: some View {
        MinutesView()
    }
}
*/
