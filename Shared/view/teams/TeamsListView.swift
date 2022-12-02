//
//  TeamsListView.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/19.
//

import SwiftUI

///球队列表
///
///选择球队
struct TeamsListView: View {
    //MARK: 配置：数据
    @Environment(\.managedObjectContext) private var viewContext

    //MARK: 球队 teams
    @FetchRequest(
        entity: Team.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    )
    private var teams: FetchedResults<Team>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(teams, id: \.self) { team in
                    NavigationLink {
                        // 修改
                        EditTeamView(team: team)
                    } label: {
                        HStack {
                            // 观察球队数据：id
                            Text("\(team.id)")
                            
                            Spacer()
                            Text(team.name)
                            
                            Spacer()
                            // 观察球队数据：球员列表（球员id）
                            Text(team.ids_player)
                            
                            Spacer()
                            Text(team.fullName)
                        }
                        
                    }
                }
                // 删除
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Teams List")
            .toolbar {
                ToolbarItem {
                    // 新增：team
                    NavigationLink {
                        NewTeamView()
                    } label: {
                        Label("Add Team", systemImage: "plus")
                    }
                }
            }
        }
        
    }
    
    /// 删除
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { teams[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TeamsListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsListView()
    }
}
