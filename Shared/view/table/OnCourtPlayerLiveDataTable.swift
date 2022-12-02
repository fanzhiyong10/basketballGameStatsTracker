//
//  OnCourtPlayerLiveDataTable.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/15.
//

import SwiftUI

///场上队员的数据表
///
///表格形式
///- header
///- row：仅场上队员
///- footer：统计：所有队员
struct OnCourtPlayerLiveDataTable: View {
    // State，设定为private。用于父子之间的视图，父亲为State，儿子为Binding
//    @State private var liveDatas = LiveData.createDataOnCourt()

    //MARK: -  队员的实时比赛数据 1）必须确保传入，2）数据可以修改，3）队员的实时比赛数据的变化，会引起统计数据的变化。
    //@Binding 队员的实时比赛数据，统计数据：计算获取
    @Binding var liveDatas : [LiveData]
    
    var body: some View {
        // 列表：竖向
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    ForEach(0...liveDatas.count-1, id:\.self) { index in
                        // 仅场上队员
                        if liveDatas[index].isOnCourt == true {
                            PlayerLiveDataRow(liveData: $liveDatas[index], height: 120)
                                .frame(height: 120) // 行高
//                                .listRowSeparator(.hidden) // 行分割线：隐藏
                                .background { // 行背景色
                                    if index % 2 == 0 {
                                        Color.gray.opacity(0.3)
                                    } else {
                                        Color.gray.opacity(0.1)
                                    }
                                }
                        }
                        
                    }
                } header: { // 表头
                    PlayerLiveDataHeader(height: 60) // 40
                        
                } footer: { // 表尾
                    PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas), height: 120) //processTotalData(liveDatas: liveDatas)
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)) // leading 8

            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
        }
    }
}

struct OnCourtPlayerLiveDataTable_Previews: PreviewProvider {
    static var previews: some View {
        OnCourtPlayerLiveDataTable(liveDatas: .constant(LiveData.createData()))
    }
}
