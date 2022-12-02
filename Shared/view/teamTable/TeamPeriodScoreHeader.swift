//
//  TeamPeriodScoreHeader.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/13.
//

import SwiftUI

struct TeamPeriodScore {
    static var shared = TeamPeriodScore()
    private init() {
        
    }
    
    let headerWords = ["", "P1", "P2", "P3", "P4", "O1", "O2", "O3", "Total"]
    let height_row = CGFloat(35)
    let width_vertical_divider = CGFloat(1.5)
    let height_header: CGFloat = 30

    func calColumnWidths() -> [CGFloat] {
        let adjust_width = CGFloat(5)
        let width = 500 / CGFloat(headerWords.count)
        
        let adjust_width2 = adjust_width * 7
        let width_headers: [CGFloat] = [width + adjust_width2, width - adjust_width, width - adjust_width, width - adjust_width, width - adjust_width, width - adjust_width, width - adjust_width, width - adjust_width, width]
        
        return width_headers
    }
}

struct TeamPeriodScoreHeader: View {
    let teamPeriodScore = TeamPeriodScore.shared
    
    var body: some View {
        let headerWords = teamPeriodScore.headerWords
        let columnWidths = teamPeriodScore.calColumnWidths()
        let height = teamPeriodScore.height_header
        
        HStack(alignment: .center, spacing: 0) {
            Text(headerWords[0])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[0], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[1])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[2])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[2], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[3])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[3], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[4])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[4], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[5])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[5], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[6])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[6], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[7])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[7], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(headerWords[8])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[8], alignment: .center)
        }
        .frame(height: height)
        .foregroundColor(.white)
        .font(.system(size: 13))
        .background {
            Color.blue
        }
    }
}

struct TeamPeriodScoreHeader_Previews: PreviewProvider {
    static var previews: some View {
        TeamPeriodScoreHeader()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
