//
//  PlayersTable.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/16.
//

import SwiftUI


func processPlayerOnCourt(liveDatas : [LiveData]) -> [Bool] {
    var result = [Bool]()
    
    for liveData in liveDatas {
        result.append(liveData.isOnCourt)
    }
    
    return result
}

struct PlayersTable: View {
    //MARK: - 全局环境变量 状态控制
    @EnvironmentObject var mainStates: MainStateControl
    
    //MARK: -  我队的比赛数据 1.必须确保生成
    @Binding var liveDatas : [LiveData]

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            List {
                Section {
                    ForEach(0...liveDatas.count-1, id:\.self) { index in
                        HStack {
                            Text("\(liveDatas[index].player!)  # \(liveDatas[index].number!)")
                                .foregroundColor(liveDatas[index].isOnCourt_backup ? .green : nil)
                                .padding(.leading, 30)
                            
                            Spacer()
                            
                            if liveDatas[index].isOnCourt_backup {
                                // 显示标记
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.blue)
                                    .padding(.trailing, 30)
                            }
                        }
                        .frame(width: 500, height: 60) // 行高
                        .font(.title)
                        .listRowSeparator(.hidden) // 行分割线：隐藏
                        .background { // 行背景色
                            if index % 2 == 0 {
                                Color.gray.opacity(0.3)
                            } else {
                                Color.gray.opacity(0.1)
                            }
                        }
                        .onTapGesture {
                            liveDatas[index].isOnCourt_backup.toggle()
                        }
                    }
                } header: { // 表头
                    HStack {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.leading, 30)
                            .onTapGesture {
                                self.cancel(liveDatas: &liveDatas)
                                
                                self.mainStates.isOnPlayers.toggle()
                            }
                        
                        Spacer()
                        
                        Text("Players")
                            .font(.title)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(.trailing, 30)
                            .onTapGesture {
                                self.save(liveDatas: &liveDatas)
                                
                                self.mainStates.isOnPlayers.toggle()
                            }

//                        Text("DONE")
//                            .font(.title)
//                            .foregroundColor(Color.white)
//                            .padding(.trailing, 30)
                    }
                    .frame(width: 500, height: 60) // 行高
                    .background(Color.orange)
                }
                // 行定位1/2：位置，需要设定2处，左侧预留空间8
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) // leading 8

            }
            // 配合行定位2/2：位置，需要设定2处
            .listStyle(PlainListStyle())
            .frame(width: 500, alignment: .center)
            
            Spacer()
        }
        
    }
    
    func cancel(liveDatas: inout [LiveData]) {
        for index in 0...liveDatas.count-1 {
            liveDatas[index].isOnCourt_backup = liveDatas[index].isOnCourt
        }
    }
    
    func save(liveDatas: inout [LiveData]) {
        for index in 0...liveDatas.count-1 {
            liveDatas[index].isOnCourt = liveDatas[index].isOnCourt_backup
        }
        
        var onCourt = liveDatas.filter { ld1 in
            return ld1.isOnCourt
        }
        
        onCourt.sort { ld1, ld2 in
            return ld1.player! < ld2.player!
        }
        
        var offCourt = liveDatas.filter { ld1 in
            return !(ld1.isOnCourt)
        }

        offCourt.sort { ld1, ld2 in
            return ld1.player! < ld2.player!
        }
        
        liveDatas = onCourt + offCourt
    }
}

struct PlayersTable_Previews: PreviewProvider {
    static var previews: some View {
        PlayersTable(liveDatas: .constant(LiveData.createData()))
    }
}
