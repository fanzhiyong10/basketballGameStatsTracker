//
//  EditPlayerView.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/18.
//

import SwiftUI

struct EditPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @ObservedObject private var playerFromViewModel: PlayerFromViewModel
    
    @ObservedObject var player: Player

    init(player: Player) {
        self.player = player
        playerFromViewModel = PlayerFromViewModel()
        playerFromViewModel.fullName = player.fullName
        playerFromViewModel.name = player.name
        playerFromViewModel.number = player.number
    }
    
    var body: some View {
        VStack {
            FormTextField(label: "Full Name", placeholder: "Fill in the full name", value: $playerFromViewModel.fullName)
            
            FormTextField(label: "Short Name", placeholder: "Fill in the short name", value: $playerFromViewModel.name)
            
            FormTextField(label: "Number", placeholder: "Fill in Number", value: $playerFromViewModel.number)
        }
        .padding(20)
        .navigationTitle("Edit Player")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    save()
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                }
            }
        }
    }
    
    /// 更新
    ///
    /// 步骤
    /// 1. 赋值：新的
    /// 2. 存储
    private func save() {
        // 更新
        player.fullName = playerFromViewModel.fullName
        player.name = playerFromViewModel.name
        player.number = playerFromViewModel.number

        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }

}

struct EditPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayerView(player: Player())
    }
}
