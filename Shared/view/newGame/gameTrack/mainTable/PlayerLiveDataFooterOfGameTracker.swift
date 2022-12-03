//
//  PlayerLiveDataFooterOfGameTracker.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/12/1.
//

import SwiftUI

struct PlayerLiveDataFooterOfGameTracker: View {
    //MARK: -  我队的比赛数据 1.必须确保生成
    @ObservedObject var gameFromViewModel: GameFromViewModel
    @ObservedObject var footer: PlayerLiveDataFromViewModel

    var height: CGFloat = 60
    
    let delta = calDeltaPercent()
    
    init(gameFromViewModel: GameFromViewModel, footer: PlayerLiveDataFromViewModel, height: CGFloat = 60) {
        self.gameFromViewModel = gameFromViewModel
        self.footer = footer
        self.height = height
    }
    
    var body: some View {
        let columnWidths = calColumnWidths()
        let fontBig_size = CGFloat(22) - delta * 5.0

        let fontMiddle_size = CGFloat(20) - delta * 5.0
        let fontMakeMiss_size = CGFloat(20) - delta * 5.0
        let fontName_size = CGFloat(16) - delta * 5.0
        let fontNameBig_size = CGFloat(20) - delta * 5.0
        
        HStack(alignment: .center, spacing: 0) {
            
            Text(self.footer.player)
                .frame(width: columnWidths[0], alignment: .center)
                .font(Font.system(size: fontNameBig_size, weight: .bold))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(self.footer.number)
                .frame(width: columnWidths[1], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(self.footer.minutes)
                .frame(width: columnWidths[2], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(self.footer.per)
                .frame(width: columnWidths[3], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            HStack(alignment: .center, spacing: 0) {
                Text(self.footer.points)
                    .frame(width: columnWidths[4], alignment: .center)
                    .font(.system(size: fontMiddle_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.ft)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[5], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.fg2)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[6], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

     
                Text(self.footer.fg3)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[7], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }
            }

            Text(self.footer.eFG)
                .frame(width: columnWidths[8], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            HStack(alignment: .center, spacing: 0) {
                Text(self.footer.assts)
                    .frame(width: columnWidths[9], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.orebs)
                    .frame(width: columnWidths[10], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.drebs)
                    .frame(width: columnWidths[11], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.steals)
                    .frame(width: columnWidths[12], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.blocks)
                    .frame(width: columnWidths[13], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.ties)
                    .frame(width: columnWidths[14], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.defs)
                    .frame(width: columnWidths[15], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.charges)
                    .frame(width: columnWidths[16], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(self.footer.tos)
                    .font(.system(size: fontBig_size))
                    .frame(width: columnWidths[17], alignment: .center)
            }
        }
        .frame(height: height)
        .foregroundColor(.white)
        .background {
            Color.gray
        }
    }
}

struct PlayerLiveDataFooterOfGameTracker_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataFooterOfGameTracker(gameFromViewModel: GameFromViewModel(), footer: PlayerLiveDataFromViewModel())
    }
}
