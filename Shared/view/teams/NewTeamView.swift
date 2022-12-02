//
//  NewTeamView.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/19.
//

import SwiftUI

struct NewTeamView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @ObservedObject private var teamFromViewModel: TeamFromViewModel
    
    init() {
        teamFromViewModel = TeamFromViewModel()
    }
    
    var body: some View {
        VStack {
            FormTextField(label: "Full Name", placeholder: "Fill in the player's full name", value: $teamFromViewModel.fullName)
            FormTextField(label: "Short Name", placeholder: "Fill in the player's short name", value: $teamFromViewModel.name)
        }
        .padding(20)
        .navigationTitle("New Team")
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
    private func save() {
        let team = Team(context: context)
        
        // id
        let aint = UserDefaults.standard.integer(forKey: "id_team")
        team.id = aint + 1
        UserDefaults.standard.set(team.id, forKey: "id_team")
        
        team.fullName = teamFromViewModel.fullName
        team.name = teamFromViewModel.name

        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        NewTeamView()
    }
}
