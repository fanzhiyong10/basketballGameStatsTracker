//
//  PlayerLiveDataTable.swift
//  basketballGameStatsTrack (iOS)
// 
//  Created by 范志勇 on 2022/11/11.
// (header: PlayerLiveDataHeader())

import SwiftUI

/// 统计数据
///
/// 说明：
/// - 队员的实时比赛数据的变化，会引起统计数据的变化
func processTotalData(liveDatas: [LiveData]) -> LiveData {
    var totalData = LiveData()
    totalData.player = "TOTALS"
    totalData.number = ""
    
    var time_cumulative: Float = 0
    var ft_make_count: Int = 0
    var ft_miss_count: Int = 0
    var fg2_make_count: Int = 0
    var fg2_miss_count: Int = 0
    var fg3_make_count: Int = 0
    var fg3_miss_count: Int = 0
    var assts_count: Int = 0
    var orebs_count: Int = 0
    var drebs_count: Int = 0
    var steals_count: Int = 0
    var blocks_count: Int = 0
    var ties_count: Int = 0
    var defs_count: Int = 0
    var charges_count: Int = 0
    var tos_count: Int = 0

    for liveData in liveDatas {
        time_cumulative += liveData.time_cumulative
        ft_make_count += liveData.ft_make_count
        ft_miss_count += liveData.ft_miss_count
        fg2_make_count += liveData.fg2_make_count
        fg2_miss_count += liveData.fg2_miss_count
        fg3_make_count += liveData.fg3_make_count
        fg3_miss_count += liveData.fg3_miss_count
        assts_count += liveData.assts_count
        orebs_count += liveData.orebs_count
        drebs_count += liveData.drebs_count
        steals_count += liveData.steals_count
        blocks_count += liveData.blocks_count
        ties_count += liveData.ties_count
        defs_count += liveData.defs_count
        charges_count += liveData.charges_count
        tos_count += liveData.tos_count
    }
    
    totalData.time_cumulative = time_cumulative
    totalData.ft_make_count = ft_make_count
    totalData.ft_miss_count = ft_miss_count
    totalData.fg2_make_count = fg2_make_count
    totalData.fg2_miss_count = fg2_miss_count
    totalData.fg3_make_count = fg3_make_count
    totalData.fg3_miss_count = fg3_miss_count
    totalData.assts_count = assts_count
    totalData.orebs_count = orebs_count
    totalData.drebs_count = drebs_count
    totalData.steals_count = steals_count
    totalData.blocks_count = blocks_count
    totalData.ties_count = ties_count
    totalData.defs_count = defs_count
    totalData.charges_count = charges_count
    totalData.tos_count = tos_count
    
    return totalData
}

///队员数据表
///
///表格形式
///- header：静态数据
///- row：动态数据，可以修改
///- footer：统计：动态数据，可以修改
///
///
///队员的实时比赛数据
///- 1）必须确保传入
///- 2）数据可以修改，
///- 3）队员的实时比赛数据的变化，会引起统计数据的变化。
///
///数据技巧
///- @Binding var liveDatas : [LiveData]
///- func processTotalData(liveDatas: [LiveData]) -> LiveData
///- PlayerLiveDataRow(liveData: $liveDatas[index])
///- PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas))
struct PlayerLiveDataTable: View {
    // State，设定为private。用于父子之间的视图，父亲为State，儿子为Binding
//    @State private var liveDatas = LiveData.createData() // 最初的数据，用于表单显示
    
    
    //MARK: -  队员的实时比赛数据 1）必须确保传入，2）数据可以修改，3）队员的实时比赛数据的变化，会引起统计数据的变化。
    //@Binding 队员的实时比赛数据，统计数据：计算获取
    @Binding var liveDatas : [LiveData]
    
    var body: some View {
        // 列表：竖向
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    ForEach($liveDatas, id:\.id) { $liveData in //.self
                        // 队员的实时比赛数据
                        PlayerLiveDataRow(liveData: $liveData)
                            .frame(height: 60) // 行高
                            .listRowSeparator(.hidden) // 行分割线：隐藏
//                            .background { // 行背景色
//                                if index % 2 == 0 {
//                                    Color.gray.opacity(0.3)
//                                } else {
//                                    Color.gray.opacity(0.1)
//                                }
//                            }
//                            .listRowInsets(EdgeInsets()) // 左侧不留空间
                    }
                } header: { // 表头
                    PlayerLiveDataHeader(height: 40) // 40
                        
                } footer: { // 表尾
                    // 关键：统计数据，依赖于计算。队员的实时比赛数据的变化，会引起统计数据的变化
                    PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas)) // LiveData.createTestData()
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)) // leading 8

            }
            .overlay(alignment: .bottomLeading) {
                // 底部统计
                PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas))
                    .padding(.leading, 8.0)
            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
        }
    }
    

    
}

struct PlayerLiveDataTable_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataTable(liveDatas: .constant(LiveData.createData()))
//            .environmentObject(MyTeamInfo())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}


struct PlayerLiveDataTable2: View {
    // State，设定为private。用于父子之间的视图，父亲为State，儿子为Binding
//    @State private var liveDatas = LiveData.createData() // 最初的数据，用于表单显示
    
    
    //MARK: -  队员的实时比赛数据 1）必须确保传入，2）数据可以修改，3）队员的实时比赛数据的变化，会引起统计数据的变化。
    //@Binding 队员的实时比赛数据，统计数据：计算获取
    @Binding var liveDatas : [LiveData]
    
    var body: some View {
        // 列表：竖向
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    ForEach(0...liveDatas.count-1, id:\.self) { index in //.self
                        // 队员的实时比赛数据
                        PlayerLiveDataRow(liveData: $liveDatas[index])
                            .frame(height: 60) // 行高
                            .listRowSeparator(.hidden) // 行分割线：隐藏
                            .background { // 行背景色
                                if index % 2 == 0 {
                                    Color.gray.opacity(0.3)
                                } else {
                                    Color.gray.opacity(0.1)
                                }
                            }
//                            .listRowInsets(EdgeInsets()) // 左侧不留空间
                    }
                } header: { // 表头
                    PlayerLiveDataHeader(height: 40) // 40
                        
                } footer: { // 表尾
                    // 关键：统计数据，依赖于计算。队员的实时比赛数据的变化，会引起统计数据的变化
                    PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas)) // LiveData.createTestData()
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)) // leading 8

            }
            .overlay(alignment: .bottomLeading) {
                // 底部统计
                PlayerLiveDataFooter(liveData: processTotalData(liveDatas: liveDatas))
                    .padding(.leading, 8.0)
            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
        }
    }
    

    
}
