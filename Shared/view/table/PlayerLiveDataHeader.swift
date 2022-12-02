//
//  PlayerLiveDataHeader.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/11.
// 

import SwiftUI

/// 与iPad12.9相比，小多少
func calDelta() -> CGFloat {
    let maxWidth = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    if maxWidth >= 1366.0 {
        return 0.0
    }
    
    return 1366.0 - maxWidth
}

func calDeltaPercent() -> CGFloat {
    return calDelta() / 1366.0
}

/// 列宽计算
///
/// 调用者
/// - header
/// - row
/// - footer
func calColumnWidths() -> [CGFloat] {
    let adjust_width = CGFloat(5)
    
    let width_screen = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
//    print("\(UIScreen.main.bounds.size)") // iPad12.9 (1366.0, 1024.0)
    let width = (width_screen - 16) / CGFloat(headerWords.count) // 间距1 16
//    print("width: \(width)")
    let adjust_width2 = adjust_width * 12 / 3
    
    let width_headers: [CGFloat] = [width + adjust_width, width - adjust_width,
                                    width - adjust_width, width - adjust_width,
                                    width - adjust_width, width + adjust_width2,
                                    width + adjust_width2, width + adjust_width2,
                                    width, width - adjust_width,
                                    width - adjust_width, width - adjust_width,
                                    width - adjust_width, width - adjust_width,
                                    width - adjust_width, width - adjust_width,
                                    width - adjust_width, width - adjust_width]
    
    return width_headers
    
}

struct PlayerLiveDataHeader: View {

    // 高度调整，适应实时数据表 及 放大的表。
    var height: CGFloat = 40
    var body: some View {
        let columnWidths = calColumnWidths()
        
        HStack(alignment: .center, spacing: 0) {
            Text(headerWords[0])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[0], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }
            
            // 不使用Divider，颜色，占位
//            Divider()
//                .background(Color.white)

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

            HStack(alignment: .center, spacing: 0) {
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
            }

            Text(headerWords[8])
                .multilineTextAlignment(.center)
                .frame(width: columnWidths[8], alignment: .center)
                .overlay(alignment: .trailing) {
                    Color.white.frame(width: 1, height: height, alignment: .trailing)
                }

            HStack(alignment: .center, spacing: 0) {
                Text(headerWords[9])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[9], height: height, alignment: .center)
                    .foregroundColor(.blue)
                    .background {
                        Color.yellow
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[10])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[10], height: height, alignment: .center)
                    .foregroundColor(.blue)
                    .background {
                        Color.orange
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[11])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[11], height: height, alignment: .center)
                    .foregroundColor(.blue)
                    .background {
                        Color.init(.sRGB, red: 1.0, green: 1.0, blue: 0, opacity: 1.0)
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[12])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[12], alignment: .center)
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[13])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[13], height: height, alignment: .center)
                    .background {
                        Color.black
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[14])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[14], height: height, alignment: .center)
                    .background {
                        Color.purple
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[15])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[15], height: height, alignment: .center)
                    .background {
                        Color.gray
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[16])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[16], height: height, alignment: .center)
                    .background {
                        Color.green
                    }
                    .overlay(alignment: .trailing) {
                        Color.white.frame(width: 1, height: height, alignment: .trailing)
                    }

                Text(headerWords[17])
                    .multilineTextAlignment(.center)
                    .frame(width: columnWidths[17], height: height, alignment: .center)
                    .background {
                        Color.red
                    }
            }
        }
        .frame(height: height)
        .foregroundColor(.white)
        .font(.system(size: 13))
        .background {
            Color.blue
        }
//        .ignoresSafeArea()
    }
}

struct PlayerLiveDataHeader_Previews: PreviewProvider {
    static var previews: some View {
        PlayerLiveDataHeader()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
