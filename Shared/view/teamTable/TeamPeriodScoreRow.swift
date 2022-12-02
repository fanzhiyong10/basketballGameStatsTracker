//
//  TeamPeriodScoreRow.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/13.
//

import SwiftUI

struct TeamPeriodScoreRow: View {
    let teamPeriodScore = TeamPeriodScore.shared
    
    var teamPeriodScores: [String]
    var body: some View {
//        let headerWords = teamPeriodScore.headerWords
        let columnWidths = teamPeriodScore.calColumnWidths()
        let height = teamPeriodScore.height_row
        
        HStack(alignment: .center, spacing: 0) {
            Text(teamPeriodScores[0])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[0], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[1])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[1], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[2])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[2], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[3])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[3], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[4])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[4], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[5])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[5], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[6])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[6], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[7])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[7], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            Text(teamPeriodScores[8])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[8], alignment: .center)
            
        }
    }
    
    
}

func createData() -> [[String]] {
    var myTeam = [String]()
    myTeam.append("My Team")
    for index in 1...8 {
        myTeam.append("\(index)")
    }
    

    var opponentTeam = [String]()
    opponentTeam.append("Opponent")
    for index in 1...8 {
        opponentTeam.append("\(index)")
    }

    return [myTeam, opponentTeam]
}

struct TeamPeriodScoreRow_Previews: PreviewProvider {
    static var previews: some View {
        TeamPeriodScoreRow(teamPeriodScores: createData()[0])
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
