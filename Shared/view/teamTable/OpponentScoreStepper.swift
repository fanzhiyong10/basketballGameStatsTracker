//
//  OpponentScoreStepper.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/13.
//

import SwiftUI

struct OpponentScoreStepper: View {
    @State private var stepAmount = 8
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("\(stepAmount)")
                .frame(width: 80, height: 48, alignment: .center)
                .font(.system(size: 28))
                .background {
                    Color.white
                }
                .border(.green, width: 2)
            
            Stepper("", value: $stepAmount, in: 0...200, step: 1)
                .frame(width: 85, height: 40, alignment: .center)
                
        }
        .frame(width: 90, height: 120, alignment: .center)
    }
}

struct OpponentScoreStepper_Previews: PreviewProvider {
    static var previews: some View {
        OpponentScoreStepper()
    }
}
