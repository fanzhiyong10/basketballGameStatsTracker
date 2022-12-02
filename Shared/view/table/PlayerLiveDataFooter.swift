//
//  PlayerLiveDataFooter.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/11.
//

import SwiftUI

struct PlayerLiveDataFooter: View {

    var liveData: LiveData
    var height: CGFloat = 60
    
    let delta = calDeltaPercent()
    
    var body: some View {
        let columnWidths = calColumnWidths()
        let fontBig_size = CGFloat(22) - delta * 5.0

        let fontMiddle_size = CGFloat(20) - delta * 5.0
        let fontMakeMiss_size = CGFloat(20) - delta * 5.0
        let fontName_size = CGFloat(16) - delta * 5.0
        let fontNameBig_size = CGFloat(20) - delta * 5.0
        
        HStack(alignment: .center, spacing: 0) {
            
            Text(liveData.player != nil ? liveData.player! : "")
                .frame(width: columnWidths[0], alignment: .center)
                .font(Font.system(size: fontNameBig_size, weight: .bold))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

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

            Text(liveData.per)
                .frame(width: columnWidths[3], alignment: .center)
                .font(.system(size: fontMiddle_size))
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            HStack(alignment: .center, spacing: 0) {
                Text(liveData.points)
                    .frame(width: columnWidths[4], alignment: .center)
                    .font(.system(size: fontMiddle_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.ft)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[5], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.fg2)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[6], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

     
                Text(liveData.fg3)
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[7], alignment: .center)
                    .font(.system(size: fontMakeMiss_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
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

                Text(liveData.orebs)
                    .frame(width: columnWidths[10], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.drebs)
                    .frame(width: columnWidths[11], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.steals)
                    .frame(width: columnWidths[12], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.blocks)
                    .frame(width: columnWidths[13], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.ties)
                    .frame(width: columnWidths[14], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.defs)
                    .frame(width: columnWidths[15], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.charges)
                    .frame(width: columnWidths[16], alignment: .center)
                    .font(.system(size: fontBig_size))
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(liveData.tos)
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

struct PlayerLiveDataFooter_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataFooter(liveData: LiveData.createTestData())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
