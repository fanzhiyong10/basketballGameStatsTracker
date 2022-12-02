//
//  NewPlayerView.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/18.
//

import SwiftUI

struct NewPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @ObservedObject private var playerFromViewModel: PlayerFromViewModel
    
    init() {
        playerFromViewModel = PlayerFromViewModel()
    }
    
    var body: some View {
        VStack {
            FormTextField(label: "Full Name", placeholder: "Fill in the player's full name", value: $playerFromViewModel.fullName)
            FormTextField(label: "Short Name", placeholder: "Fill in the player's short name", value: $playerFromViewModel.name)
            
            FormTextField(label: "Number", placeholder: "Fill in Number", value: $playerFromViewModel.number)
        }
        .padding(20)
        .navigationTitle("New Player")
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
//                        .foregroundColor(Color("NavigationBarTitle"))
                }
            }
        }
    }
    
    /// 保存：新增的队员
    ///
    /// 对应ID：自增设计
    private func save() {
        let player = Player(context: context)
        
        // id
        let aint = UserDefaults.standard.integer(forKey: "id_player")
        player.id = aint + 1
        UserDefaults.standard.set(player.id, forKey: "id_player")
        
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

struct NewPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerView()
    }
}

struct FormTextField: View {
    let label: String
    var placeholder: String = ""
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextField(placeholder, text: $value)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.vertical, 10)
                
        }
    }
}

struct FormTextView: View {
    
    let label: String
    
    @Binding var value: String
    
    var height: CGFloat = 200.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextEditor(text: $value)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.top, 10)
                
        }
    }
}
