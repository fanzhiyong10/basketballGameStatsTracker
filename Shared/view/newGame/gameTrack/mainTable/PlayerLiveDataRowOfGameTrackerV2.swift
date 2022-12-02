//
//  PlayerLiveDataRowOfGameTrackerV2.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

import Speech

struct PlayerLiveDataRowOfGameTrackerV2: View {
    //MARK: - 全局环境变量 状态控制
//    @EnvironmentObject var mainStates: MainStateControl

    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    //@Binding var periodDataOfOpponentTeamFromViewModels: [PeriodDataOfOpponentTeamFromViewModel]

    // 行索引
    var index: Int

    
    @State var counter_tap = 0
    
    var height: CGFloat = 60
    
    
    let delta = calDeltaPercent()
    
    init(gameFromViewModel: GameFromViewModel, index: Int) {
        self.gameFromViewModel = gameFromViewModel
        self.index = index
    }
    
    var body: some View {
        let columnWidths = calColumnWidths()
        let fontBig_size = CGFloat(22) - delta * 5.0

        let fontMiddle_size = CGFloat(20) - delta * 5.0
        let fontMakeMiss_size = CGFloat(20) - delta * 5.0
        let fontName_size = CGFloat(16) - delta * 5.0
        let fontNameBig_size = CGFloat(20) - delta * 5.0

        // 需要设定spacing: 0，缺省不为0
        HStack(alignment: .center, spacing: 0) {
            // nil检测
            Text(gameFromViewModel.playerLiveDataFromViewModels[index].player)
                .frame(width: columnWidths[0], alignment: .center) // 列宽
                .overlay(alignment: .trailing) {
                    // 分隔符：列
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .font(gameFromViewModel.playerLiveDataFromViewModels[index].isOnCourt == true ? Font.system(size: fontNameBig_size, weight: .bold) : Font.system(size: fontName_size))
                .foregroundColor(gameFromViewModel.playerLiveDataFromViewModels[index].isOnCourt == true ? Color.green : nil)

            Text(gameFromViewModel.playerLiveDataFromViewModels[index].number)
                .frame(width: columnWidths[1], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(gameFromViewModel.playerLiveDataFromViewModels[index].minutes)
                .frame(width: columnWidths[2], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onReceive(NotificationCenter.default.publisher(for: .time_count)) { _ in
                    if gameFromViewModel.playerLiveDataFromViewModels[index].isOnCourt {
                        gameFromViewModel.playerLiveDataFromViewModels[index].time_cumulative += 1
                    }
                }
            

            Text(gameFromViewModel.playerLiveDataFromViewModels[index].per)
                .frame(width: columnWidths[3], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // HStack最多有10个，因此需要再分组，使用HStack
            HStack(alignment: .center, spacing: 0) { // 4 - 7
                Text(gameFromViewModel.playerLiveDataFromViewModels[index].points)
                    .frame(width: columnWidths[4], alignment: .center)
                    .font(.system(size: fontMiddle_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].ft)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[5], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                                self.liveData.ft_make_count += self.plus_minus
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                // 算法：最小为0
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].ft_make_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].ft_make_count = result >= 0 ? result : 0
                                
                                // 发出通知 toMake
                                NotificationCenter.default.post(name: .toMake, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                                self.liveData.ft_miss_count += self.plus_minus
//                            }
                        
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].ft_miss_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].ft_miss_count = result >= 0 ? result : 0
                                
                                // 发出通知 toMiss
                                NotificationCenter.default.post(name: .toMiss, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }
                    }


                Text(gameFromViewModel.playerLiveDataFromViewModels[index].fg2)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[6], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].fg2_make_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].fg2_make_count = result >= 0 ? result : 0
                                
                                // 发出通知 toBucket
                                NotificationCenter.default.post(name: .toBucket, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }

                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                            }
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].fg2_miss_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].fg2_miss_count = result >= 0 ? result : 0
                                
                                // 发出通知 toBrick
                                NotificationCenter.default.post(name: .toBrick, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }
                    }

     
                Text(gameFromViewModel.playerLiveDataFromViewModels[index].fg3)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[7], height: height, alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .overlay(alignment: .topTrailing) {
                        // 不能使用Button，如果是Button，则所有单元格都响应点击事件
//                        Text("+").foregroundColor(.green)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("+")
//                            }
                        
                        Image(systemName: "circle.fill")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.green)
                            .onTapGesture {
                                print("+")
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].fg3_make_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].fg3_make_count = result >= 0 ? result : 0
                                
                                // 发出通知 toSwish
                                NotificationCenter.default.post(name: .toSwish, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
                    .overlay(alignment: .topLeading) {
//                        Text("-").foregroundColor(.red)
//                            .font(.system(size: 32))
//                            .frame(width: 40, alignment: .center)
//                            .onTapGesture {
//                                print("-")
//                            }
                        
                        Image(systemName: "circle")
                            .frame(width: 40, alignment: .center)
                            .foregroundColor(.red)
                            .onTapGesture {
                                print("-")
                                let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].fg3_miss_count + self.gameFromViewModel.value
                                self.gameFromViewModel.playerLiveDataFromViewModels[index].fg3_miss_count = result >= 0 ? result : 0
                                
                                // 发出通知 toOff
                                NotificationCenter.default.post(name: .toOff, object: self)
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
            }
            

            Text(gameFromViewModel.playerLiveDataFromViewModels[index].eFG)
                .frame(width: columnWidths[8], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                

            HStack(alignment: .center, spacing: 0) {
                Text(gameFromViewModel.playerLiveDataFromViewModels[index].assts)
                    .frame(width: columnWidths[9], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].assts_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].assts_count = result >= 0 ? result : 0
                        
                        // 发出通知 toDime
                        NotificationCenter.default.post(name: .toDime, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].orebs)
                    .frame(width: columnWidths[10], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].orebs_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].orebs_count = result >= 0 ? result : 0
                        
                        // 发出通知 toBoard
                        NotificationCenter.default.post(name: .toBoard, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].drebs)
                    .frame(width: columnWidths[11], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].drebs_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].drebs_count = result >= 0 ? result : 0
                        
                        // 发出通知 toGlass
                        NotificationCenter.default.post(name: .toGlass, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].steals)
                    .frame(width: columnWidths[12], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].steals_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].steals_count = result >= 0 ? result : 0
                        
                        // 发出通知 toSteal
                        NotificationCenter.default.post(name: .toSteal, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].blocks)
                    .frame(width: columnWidths[13], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].blocks_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].blocks_count = result >= 0 ? result : 0
                        
                        // 发出通知 toBlock
                        NotificationCenter.default.post(name: .toBlock, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].ties)
                    .frame(width: columnWidths[14], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].ties_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].ties_count = result >= 0 ? result : 0
                        
                        // 发出通知 toTie
                        NotificationCenter.default.post(name: .toTie, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].defs)
                    .frame(width: columnWidths[15], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].defs_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].defs_count = result >= 0 ? result : 0
                        
                        // 发出通知 toTip
                        NotificationCenter.default.post(name: .toTip, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].charges)
                    .frame(width: columnWidths[16], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].charges_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].charges_count = result >= 0 ? result : 0
                        
                        // 发出通知 toCharge
                        NotificationCenter.default.post(name: .toCharge, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(gameFromViewModel.playerLiveDataFromViewModels[index].tos)
                    .frame(width: columnWidths[17], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .onTapGesture {
                        let result = self.gameFromViewModel.playerLiveDataFromViewModels[index].tos_count + self.gameFromViewModel.value
                        self.gameFromViewModel.playerLiveDataFromViewModels[index].tos_count = result >= 0 ? result : 0
                        
                        // 发出通知 toBad
                        NotificationCenter.default.post(name: .toBad, object: self)
                        
                        // 提示声音
                        self.playSound()
                    }
            }
            
        }
        
        
    }
    
//    func playSound(_ block: @escaping () -> ()) {
    func playSound() {
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback)

        if let URL = Bundle.main.url(forResource: "ding", withExtension: "wav") {
            print("ding.wav")
            let audioEngine = AVAudioEngine()
            let playerNode = AVAudioPlayerNode()
            
            // Attach the player node to the audio engine.
            audioEngine.attach(playerNode)
            
            // Connect the player node to the output node.
            if let file = try? AVAudioFile(forReading: URL) {
                print("file ding.wav")
                audioEngine.connect(playerNode,
                                    to: audioEngine.outputNode,
                                    format: file.processingFormat)
                print("file ding.wav file.fileFormat")
                //        Then schedule the audio file for full playback. The callback notifies your app when playback completes.
                playerNode.scheduleFile(file, at: nil,
                                        completionCallbackType: .dataPlayedBack) { _ in
                    print("file ding.wav end")
                    audioEngine.stop()
                    
                    // 启动声控
//                    self.startVoiceListening()
//                    block()
                }
                
                // Before you play the audio, start the engine.
                do {
                    try audioEngine.start()
                    playerNode.play()
                } catch {
                    /* Handle the error. */
                }
            }
        }
    }
}

struct PlayerLiveDataRowOfGameTrackerV2_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataRowOfGameTrackerV2(gameFromViewModel: GameFromViewModel(), index: 0)
    }
}
