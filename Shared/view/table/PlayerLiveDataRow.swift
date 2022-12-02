//
//  PlayerLiveDataRow.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/11.
//liveData.isOnCourt == true ?? font(.system(size: 20)) : font(.system(size: 12))

import SwiftUI
import Speech


extension Notification.Name {
    // 计时
    static let time_count = Notification.Name("time_count")
}

struct PlayerLiveDataRow: View {
    
    @Binding var liveData: LiveData
    var height: CGFloat = 60
    
    //MARK: - 全局环境变量使用，仅读
    @EnvironmentObject var plusMinus: MainStateControl
    
    let delta = calDeltaPercent()
    
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
            Text(liveData.player != nil ? liveData.player! : "")
                .frame(width: columnWidths[0], alignment: .center) // 列宽
                .overlay(alignment: .trailing) {
                    // 分隔符：列
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .font(liveData.isOnCourt == true ? Font.system(size: fontNameBig_size, weight: .bold) : Font.system(size: fontName_size))
                .foregroundColor(liveData.isOnCourt == true ? Color.green : nil)

            Text(liveData.number != nil ? liveData.number! : "")
                .frame(width: columnWidths[1], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(liveData.minutes)
                .frame(width: columnWidths[2], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                .onReceive(NotificationCenter.default.publisher(for: .time_count)) { _ in
                    if liveData.isOnCourt {
                        liveData.time_cumulative += 1
                    }
                }
            

            Text(liveData.per)
                .frame(width: columnWidths[3], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            // HStack最多有10个，因此需要再分组，使用HStack
            HStack(alignment: .center, spacing: 0) { // 4 - 7
                Text(liveData.points)
                    .frame(width: columnWidths[4], alignment: .center)
                    .font(.system(size: fontMiddle_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.ft)
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
                                let result = self.liveData.ft_make_count + self.plusMinus.value
                                self.liveData.ft_make_count = result >= 0 ? result : 0
                                
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
                                let result = self.liveData.ft_miss_count + self.plusMinus.value
                                self.liveData.ft_miss_count = result >= 0 ? result : 0
                                
                                // 提示声音
                                self.playSound()
                            }
                    }


                Text(liveData.fg2)
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
                                let result = self.liveData.fg2_make_count + self.plusMinus.value
                                self.liveData.fg2_make_count = result >= 0 ? result : 0
                                
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
                                let result = self.liveData.fg2_miss_count + self.plusMinus.value
                                self.liveData.fg2_miss_count = result >= 0 ? result : 0
                                
                                // 提示声音
                                self.playSound()
                            }
                    }

     
                Text(liveData.fg3)
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
                                let result = self.liveData.fg3_make_count + self.plusMinus.value
                                self.liveData.fg3_make_count = result >= 0 ? result : 0
                                
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
                                let result = self.liveData.fg3_miss_count + self.plusMinus.value
                                self.liveData.fg3_miss_count = result >= 0 ? result : 0
                                
                                // 提示声音
                                self.playSound()
                            }
                    }
            }
            

            Text(liveData.eFG)
                .frame(width: columnWidths[8], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
                

            HStack(alignment: .center, spacing: 0) {
                Text(liveData.assts)
                    .frame(width: columnWidths[9], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.assts_count + self.plusMinus.value
                        self.liveData.assts_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.orebs)
                    .frame(width: columnWidths[10], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.orebs_count + self.plusMinus.value
                        self.liveData.orebs_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.drebs)
                    .frame(width: columnWidths[11], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.drebs_count + self.plusMinus.value
                        self.liveData.drebs_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.steals)
                    .frame(width: columnWidths[12], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.steals_count + self.plusMinus.value
                        self.liveData.steals_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.blocks)
                    .frame(width: columnWidths[13], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.blocks_count + self.plusMinus.value
                        self.liveData.blocks_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.ties)
                    .frame(width: columnWidths[14], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.ties_count + self.plusMinus.value
                        self.liveData.ties_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.defs)
                    .frame(width: columnWidths[15], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.defs_count + self.plusMinus.value
                        self.liveData.defs_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.charges)
                    .frame(width: columnWidths[16], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
                    .onTapGesture {
                        let result = self.liveData.charges_count + self.plusMinus.value
                        self.liveData.charges_count = result >= 0 ? result : 0
                        
                        // 提示声音
                        self.playSound()
                    }

                Text(liveData.tos)
                    .frame(width: columnWidths[17], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .onTapGesture {
                        let result = self.liveData.tos_count + self.plusMinus.value
                        self.liveData.tos_count = result >= 0 ? result : 0
                        
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

struct PlayerLiveDataRow_Previews: PreviewProvider {
    static var previews: some View {
        // 绑定Binding，使用.constant(LiveData.createTestData())
        PlayerLiveDataRow(liveData: .constant(LiveData.createTestData()))
            .environmentObject(MainStateControl())
            .previewInterfaceOrientation(.landscapeRight)
    }
}

