//
//  TeamInfo.swift
//  basketballStatsTracker
//
//  Created by 范志勇 on 2022/10/17.
//

import UIKit



/// 主队信息
///
/// 场景说明
/// - 当前正在比赛的小节，可以修改
/// - 选中几个小节（比赛已经结束），不能修改
/// - 选中的小节（1个）（比赛尚未结束，该小节已经结束），可以修改
/// - 表单显示的数据
class MyTeamInfo: ObservableObject {
    init() {
        self.newGameOfMyTeamInfos()
    }
    
    /// 1.1 主队
    ///
    /// 包括
    /// - 1.1 第1小节
    /// - 1.1 第2-7小节
    func newGameOfMyTeamInfos() {
        self.periodInfos = [PeriodInfo]()
        
        self.newPeriod1()
        self.processPeriod2_7()
        
        // 测试
        print(self.toStringOfCsv()!)
    }
    
    func newPeriod1() {
        let periodInfo = PeriodInfo()
        periodInfo.name = "P1"
//        periodInfo.liveDatas = self.liveDatasWithoutPlaying
        periodInfo.liveDatas = LiveData.createData()
        periodInfo.status = .NotStart // IsPlayingOnDisplay
        periodInfo.isSelected = true
        periodInfo.isHighlight = true
        
        self.periodInfos.append(periodInfo)
    }
    
    func processPeriod2_7() {
        for index in 2...7 {
            let periodInfo = PeriodInfo()
            if index < 5 {
                periodInfo.name = "P\(index)"
            } else {
                periodInfo.name = "O\(index - 4)"
            }
//            periodInfo.liveDatas = self.liveDatasWithoutPlaying
            periodInfo.liveDatas = LiveData.createData()
            periodInfo.status = .NotStart
            periodInfo.isSelected = false
            periodInfo.isHighlight = false
            
            self.periodInfos.append(periodInfo)
        }
    }
    
    // 队名
    var name: String? = "Team"
    
    // 7个小节的比赛数据
    @Published var periodInfos = [PeriodInfo]()
    
    // 比赛得分
    var score: Int {
        var total = 0
        if periodInfos != nil {
            for item in periodInfos {
                total += item.score // 得分
            }
        }
        return total
    }
    
    var hasSorted = false
    
    var periodOnPlaying: PeriodInfo? {
        guard self.periodInfos != nil else {
            return nil
        }
        
        if self.periodInfos.first?.status == .NotStart {
            // 第一个
            return (self.periodInfos.first)!
        }
        
        for pinf in self.periodInfos {
            switch pinf.status {
            case .IsPlayingOnDisplay, .IsPlayingOffDisplay:
                
                if hasSorted == false {
                    // 排序
                    var arr_onCourt = [LiveData]()
                    var arr_notOnCourt = [LiveData]()
                    for livedata in pinf.liveDatas {
                        if livedata.isOnCourt {
                            arr_onCourt.append(livedata)
                        } else {
                            arr_notOnCourt.append(livedata)
                        }
                    }
                    
                    pinf.liveDatas = arr_onCourt + arr_notOnCourt
                    
                    hasSorted = true
                }
                
                return pinf
            default:
                break
            }
        }
        
        return nil
//        return (self.periodInfos?.first)!
    }
    
    
    // 正在比赛中的小节索引
    var indexOfPeriodOnPlaying: Int? {
        guard self.periodInfos != nil else {
            return nil
        }
        
        for (index, pinf) in self.periodInfos.enumerated() {
            switch pinf.status {
            case .IsPlayingOnDisplay, .IsPlayingOffDisplay:
                return index
            default:
                break
            }
        }
        
        return nil
    }
    
    // 高亮的小节数量
    var countOfPeriodOnHighlight: Int? {
        guard self.periodInfos != nil else {
            return nil
        }
        
        var count = 0
        for pinf in self.periodInfos {
            if pinf.isHighlight {
                count += 1
            }
        }
        
        return count
    }
    
    // 多个高亮时的合并数据，不能做修改，不包括正在比赛中的。比赛的另外计算
    var liveDatasOnHighlight: [LiveData] {
        print("liveDatasOnHighlight")
        if countOfPeriodOnHighlight == 1 {
            print("if countOfPeriodOnHighlight == 1")
            // 将高亮的返回
            for pinf in self.periodInfos {
                if pinf.isHighlight {
                    return pinf.liveDatas
                }
            }
        } else {
            print("statisticsLiveData")
            // 创建一个统计数组，并返回，排序按照字母顺序
            var statisticsLiveData = liveDatasWithoutPlaying
            
            for pinf in self.periodInfos {
                if pinf.isHighlight {
                    for (index, ld) in pinf.liveDatas.enumerated() {
                        statisticsLiveData[index].time_cumulative += ld.time_cumulative
                        
                        statisticsLiveData[index].ft_make_count += ld.ft_make_count
                        statisticsLiveData[index].ft_miss_count += ld.ft_miss_count
                        
                        statisticsLiveData[index].fg2_make_count += ld.fg2_make_count
                        statisticsLiveData[index].fg2_miss_count += ld.fg2_miss_count
                        
                        statisticsLiveData[index].fg3_make_count += ld.fg3_make_count
                        statisticsLiveData[index].fg3_miss_count += ld.fg3_miss_count
                        
                        statisticsLiveData[index].assts_count += ld.assts_count
                        statisticsLiveData[index].orebs_count += ld.orebs_count
                        statisticsLiveData[index].drebs_count += ld.drebs_count
                        statisticsLiveData[index].steals_count += ld.steals_count
                        statisticsLiveData[index].blocks_count += ld.blocks_count
                        statisticsLiveData[index].defs_count += ld.defs_count
                        statisticsLiveData[index].charges_count += ld.charges_count
                        statisticsLiveData[index].tos_count += ld.tos_count
                        
                        if ld.isOnCourt {
                            statisticsLiveData[index].isOnCourt = ld.isOnCourt
                        }
                    }
                }
            }
            return statisticsLiveData
        }
//        return nil
        return self.periodInfos[0].liveDatas
    }
    
    @Published var liveDatasWithoutPlaying2 = LiveData.createData()
    
    var liveDatasWithoutPlaying: [LiveData] {
        var result = [LiveData]()
        
        for tmp in self.periodInfos[0].liveDatas {
            var ld = LiveData()
            
            ld.id = tmp.id
            ld.player = tmp.player
            ld.number = tmp.number
//            ld.isOnCourt = tmp.isOnCourt
            
            result.append(ld)
        }
        print("liveDatasWithoutPlaying")
        return result
    }
    
    var liveDatasWithPlaying: [LiveData] {
        var result = [LiveData]()
        
        for tmp in self.periodInfos[0].liveDatas {
            var ld = LiveData()
            
            ld.id = tmp.id
            ld.player = tmp.player
            ld.number = tmp.number
            ld.isOnCourt = tmp.isOnCourt
            ld.isOnCourt_backup = tmp.isOnCourt

            result.append(ld)
        }
        print("liveDatasWithPlaying")
        
        var onCourt = result.filter { ld1 in
            return ld1.isOnCourt
        }
        
        onCourt.sort { ld1, ld2 in
            return ld1.player! < ld2.player!
        }
        
        var offCourt = result.filter { ld1 in
            return !(ld1.isOnCourt)
        }

        offCourt.sort { ld1, ld2 in
            return ld1.player! < ld2.player!
        }
        
        return onCourt + offCourt
    }
    
    // 当前比赛的小节是否在选中的多个高亮中
    var isPlayingInMultiHighlight: Bool {
        guard self.countOfPeriodOnHighlight != nil else {
            return false
        }
        
        // 必须是多选
        if self.countOfPeriodOnHighlight! <= 1 {
            return false
        }
        
        return periodOnPlaying!.isHighlight
    }
    
    // 应当使用id（不变）来排序，用于统计分析
    func sortAllPeriods() {
        guard self.periodInfos != nil else {
            return
        }
        /*
        for pInfo in self.periodInfos! {
            pInfo.liveDatas?.sort { (s1, s2) -> Bool in
                   if isPlayerSpace(s1.player!) {
                       return false
                   }
                   
                   let tmp = s1.player! < s2.player!
                   
                   return tmp
            }
        }
        */
        for pInfo in self.periodInfos {
            pInfo.liveDatas.sort { (s1, s2) -> Bool in
                   let tmp = s1.id < s2.id
                   
                   return tmp
            }
        }
    }
    
    func isPlayerSpace(_ player: String) -> Bool {
        if player.hasPrefix(" ") {
            let str = player
            
            for a in str {
                if a != " " {
                    return false
                }
            }
            
            return true
        }
        
        return false
    }
    
    func setOnCourt(current: Int, next: Int) {
        var result = [LiveData]()
        
        for tmp in self.periodInfos[current].liveDatas {
            var ld = LiveData()
            
            ld.id = tmp.id
            ld.player = tmp.player
            ld.number = tmp.number
            ld.isOnCourt = tmp.isOnCourt
            
            result.append(ld)
        }
        
        self.periodInfos[next].liveDatas = result
    }
    
    func toStringOfCsv() -> String? {
        guard self.periodInfos != nil else {
            return nil
        }
        
        var str = ""
        // 第一行：头
        str += "Period"
        for word in headerWordsPart1 {
            str += "," + word
        }
        
        for word in headerWordsPart2 {
            str += "," + word
        }
        
        str += "\n"
        // 实际数据
        for (index, pInfo) in periodInfos.enumerated() {
            if pInfo.status == .NotStart {
                break
            }
            if let csv = pInfo.toStringOfCsv() {
                str += csv
                
                // 最后一个没有换行符"\n"
                if index < periodInfos.count - 1 {
                    if periodInfos[index + 1].status == .NotStart {
                        //
                    } else {
                        str += "\n"
                    }
                }
            }
        }
        
        return str
    }
}

/// 小节信息
class PeriodInfo: ObservableObject {
    var name = "P1"
    // 比赛数据
    @Published var liveDatas = [LiveData]()
    
    // 小节得分
    var score: Int {
        var total = 0
        if liveDatas != nil {
            for ld in liveDatas {
                total += ld.points_cal // 得分u
            }
        }
        return total
    }
    
    // 比赛状态
    var status = PeriodStatus.NotStart // 初始状态：未开始
    
    // 是否选中
    var isSelected = false
    
    // 是否红框
    var isHighlight = false
    
    func toStringOfCsv() -> String? {
        guard self.liveDatas != nil else {
            return nil
        }
        
        var str = ""
        for (index, ld) in self.liveDatas.enumerated() {
            str += name + ","
            if let csv = ld.toStringOfCSV() {
                str += csv
                
                if index < self.liveDatas.count - 1 {
                    str += "\n"
                }
            }
        }
        
        return str
    }
}

///客队（对手）信息
class OpponentTeamInfo {
    // 队名
    var name: String? = "Opponent"
    
    // 小节得分
    var periodScores: [Int]?
    
    // 比赛得分
    var score: Int {
        var total = 0
        if periodScores != nil {
            for item in periodScores! {
                total += item // 得分
            }
        }
        return total
    }
}

