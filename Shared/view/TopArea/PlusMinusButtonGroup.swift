//
//  PlusMinusButtonGroup.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/13.
// 

import SwiftUI

struct PlusMinusButtonGroup: View {
    //MARK: - 绑定
    @Binding var plus_minus: Int
    
    @State var isEnhanced = true
    
    var body: some View {
        HStack(spacing: 0) {
            Toggle("Enhance Sound", isOn: $isEnhanced)
                .toggleStyle(.switch)
            
            Button {
                print("plus_minus = 1")
                plus_minus = 1
            } label: {
                Text("+")
                    .frame(width: 60, height: 40, alignment: .center)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    
//                                .overlay( // 按钮的边框
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.blue, lineWidth: 2)
//                                )
                    
            }
            .background {
                Color.blue
            }
            .cornerRadius(10)
            
            Button {
                print("plus_minus = -1")
                plus_minus = -1
            } label: {
                Text("-")
                    .frame(width: 60, height: 40, alignment: .center)
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    
                    .overlay( // 按钮的边框
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    
            }
            .background {
                Color.white
            }
            .cornerRadius(10)

        }
    }
}

struct PlusMinusButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        PlusMinusButtonGroup(plus_minus: .constant(1))
    }
}
